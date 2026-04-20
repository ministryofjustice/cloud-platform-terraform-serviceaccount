locals {
  github_repositories = toset([
    for repository in var.github_repositories : {
      repository = repository
    }
  ])

  github_environments = toset([
    for environment in var.github_environments : {
      environment = environment
    }
  ])

  github_repo_environments = [
    for pair in setproduct(local.github_repositories, local.github_environments) : {
      repository  = pair[0].repository
      environment = pair[1].environment

    }
  ]
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.serviceaccount_name
    namespace = var.namespace
  }
}

resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    name      = "${var.serviceaccount_name}-token-${var.serviceaccount_token_rotated_date}"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = var.serviceaccount_name
      "secret-rotated-date"                = var.serviceaccount_token_rotated_date
    }
  }

  type = "kubernetes.io/service-account-token"

  depends_on = [
    kubernetes_service_account.this
  ]
}

resource "kubernetes_role" "this" {
  metadata {
    name      = var.role_name
    namespace = var.namespace
  }

  dynamic "rule" {
    for_each = var.serviceaccount_rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = var.rolebinding_name
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = var.namespace
  }
}

resource "github_actions_secret" "serviceaccount_cert" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_cert
  plaintext_value = lookup(kubernetes_secret_v1.serviceaccount_token.data, "ca.crt")
}

resource "github_actions_secret" "serviceaccount_token" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_token
  plaintext_value = lookup(kubernetes_secret_v1.serviceaccount_token.data, "token")
}

resource "github_actions_secret" "cluster_name" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_cluster
  plaintext_value = var.kubernetes_cluster
}

resource "github_actions_secret" "cluster_namespace" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_namespace
  plaintext_value = var.namespace
}

# Create environment secrets

resource "github_actions_environment_secret" "serviceaccount_cert" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_cert
  plaintext_value = sensitive(lookup(kubernetes_secret_v1.serviceaccount_token.data, "ca.crt"))
}

resource "github_actions_environment_secret" "serviceaccount_token" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_token
  plaintext_value = sensitive(lookup(kubernetes_secret_v1.serviceaccount_token.data, "token"))
}

resource "github_actions_environment_secret" "cluster_name" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_cluster
  plaintext_value = var.kubernetes_cluster
}

resource "github_actions_environment_secret" "cluster_namespace" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_namespace
  plaintext_value = var.namespace
}

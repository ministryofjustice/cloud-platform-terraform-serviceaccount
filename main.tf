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

resource "kubernetes_service_account" "github_actions_serviceaccount" {
  metadata {
    name      = var.serviceaccount_name
    namespace = var.namespace
  }
}

resource "kubernetes_secret_v1" "serviceaccount-token" {
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
    kubernetes_service_account.github_actions_serviceaccount
  ]
}

resource "kubernetes_role" "github_actions_role" {
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

resource "kubernetes_role_binding" "github-actions-rolebinding" {
  metadata {
    name      = var.rolebinding_name
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.github_actions_role.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.github_actions_serviceaccount.metadata[0].name
    namespace = var.namespace
  }
}

resource "github_actions_secret" "serviceaccount-cert" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_cert
  plaintext_value = lookup(kubernetes_secret_v1.serviceaccount-token.data, "ca.crt")
}

resource "github_actions_secret" "serviceaccount-token" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_token
  plaintext_value = lookup(kubernetes_secret_v1.serviceaccount-token.data, "token")
}

resource "github_actions_secret" "cluster-name" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_cluster
  plaintext_value = var.kubernetes_cluster
}

resource "github_actions_secret" "cluster-namespace" {
  for_each        = length(var.github_environments) == 0 ? toset(var.github_repositories) : []
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_namespace
  plaintext_value = var.namespace
}

# Create environment secrets

resource "github_actions_environment_secret" "serviceaccount-cert" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_cert
  plaintext_value = sensitive(lookup(kubernetes_secret_v1.serviceaccount-token.data, "ca.crt"))
}

resource "github_actions_environment_secret" "serviceaccount-token" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_token
  plaintext_value = sensitive(lookup(kubernetes_secret_v1.serviceaccount-token.data, "token"))
}

resource "github_actions_environment_secret" "cluster-name" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_cluster
  plaintext_value = var.kubernetes_cluster
}

resource "github_actions_environment_secret" "cluster-namespace" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_kube_namespace
  plaintext_value = var.namespace
}

resource "kubernetes_service_account" "github_actions_serviceaccount" {
  metadata {
    name      = var.serviceaccount_name
    namespace = var.namespace
  }
}

data "kubernetes_secret" "github_actions_secret" {
  metadata {
    name      = kubernetes_service_account.github_actions_serviceaccount.default_secret_name
    namespace = var.namespace
  }
}

resource "kubernetes_role" "github_actions_role" {
  metadata {
    name      = var.role_name
    namespace = var.namespace
  }

  dynamic rule {
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
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_cert
  plaintext_value = lookup(data.kubernetes_secret.github_actions_secret.data, "ca.crt")
}

resource "github_actions_secret" "serviceaccount-token" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_token
  plaintext_value = lookup(data.kubernetes_secret.github_actions_secret.data, "token")
}

resource "github_actions_secret" "cluster-name" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_cluster
  plaintext_value = var.kubernetes_cluster
}

resource "github_actions_secret" "cluster-namespace" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_kube_namespace
  plaintext_value = var.namespace
}

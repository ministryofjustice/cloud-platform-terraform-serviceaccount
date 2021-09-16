variable "kubernetes_cluster" {
  description = "The name of the kubernetes cluster, for app. deployment"
}

variable "namespace" {
  description = "The namespace in which this serviceaccount will be created"
}

variable "serviceaccount_name" {
  description = "The name of the serviceaccount"
  default     = "cd-serviceaccount"
}

variable "serviceaccount_rules" {
  description = "The capabilities of this serviceaccount"

  type = list(object({
    api_groups = list(string),
    resources  = list(string),
    verbs      = list(string)
  }))

  # These values are usually sufficient for a CI/CD pipeline
  default = [
    {
      api_groups = [""]
      resources = [
        "pods/portforward",
        "deployment",
        "secrets",
        "services",
        "pods",
      ]
      verbs = [
        "patch",
        "get",
        "create",
        "update",
        "delete",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "extensions",
        "apps",
        "batch",
        "networking.k8s.io",
      ]
      resources = [
        "deployments",
        "ingresses",
        "cronjobs",
        "jobs",
      ]
      verbs = [
        "get",
        "update",
        "delete",
        "create",
        "patch",
        "list",
        "watch",
      ]
    },
  ]
}

variable "role_name" {
  default = "serviceaccount-role"
}

variable "rolebinding_name" {
  default = "serviceaccount-rolebinding"
}

variable "github_repositories" {
  description = "GitHub repositories in which to create github actions secrets"
  type        = list(string)
  default     = []
}

variable "github_actions_secret_kube_cluster" {
  description = "The name of the github actions secret containing the kubernetes cluster name"
  default     = "KUBE_CLUSTER"
}

variable "github_actions_secret_kube_namespace" {
  description = "The name of the github actions secret containing the kubernetes namespace name"
  default     = "KUBE_NAMESPACE"
}

variable "github_actions_secret_kube_cert" {
  description = "The name of the github actions secret containing the serviceaccount ca.crt"
  default     = "KUBE_CERT"
}

variable "github_actions_secret_kube_token" {
  description = "The name of the github actions secret containing the serviceaccount token"
  default     = "KUBE_TOKEN"
}

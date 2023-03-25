variable "kubernetes_cluster" {
  description = "The name of the kubernetes cluster, for app. deployment"
  type        = string
}

variable "namespace" {
  description = "The namespace in which this serviceaccount will be created"
  type        = string
}

variable "serviceaccount_name" {
  description = "The name of the serviceaccount"
  default     = "cd-serviceaccount"
  type        = string
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
        "configmaps",
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
        "policy",
      ]
      resources = [
        "deployments",
        "ingresses",
        "cronjobs",
        "jobs",
        "replicasets",
        "poddisruptionbudgets",
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
    {
      api_groups = [
        "monitoring.coreos.com",
      ]
      resources = [
        "prometheusrules",
      ]
      verbs = [
        "*",
      ]
    },
  ]
}

variable "role_name" {
  default     = "serviceaccount-role"
  description = "Kubernetes role name"
  type        = string
}

variable "rolebinding_name" {
  description = "Kubernetes to GitHub actions rolebinding name"
  default     = "serviceaccount-rolebinding"
  type        = string
}

variable "github_repositories" {
  description = "GitHub repositories in which to create github actions secrets"
  type        = list(string)
  default     = []
}

variable "github_environments" {
  description = "GitHub environment in which to create github actions secrets"
  type        = list(string)
  default     = []
}

variable "github_actions_secret_kube_cluster" {
  description = "The name of the github actions secret containing the kubernetes cluster name"
  default     = "KUBE_CLUSTER"
  type        = string
}

variable "github_actions_secret_kube_namespace" {
  description = "The name of the github actions secret containing the kubernetes namespace name"
  default     = "KUBE_NAMESPACE"
  type        = string
}

variable "github_actions_secret_kube_cert" {
  description = "The name of the github actions secret containing the serviceaccount ca.crt"
  default     = "KUBE_CERT"
  type        = string
  sensitive   = true
}

variable "github_actions_secret_kube_token" {
  description = "The name of the github actions secret containing the serviceaccount token"
  default     = "KUBE_TOKEN"
  type        = string
  sensitive   = true
}

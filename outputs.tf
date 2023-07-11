output "service_account" {
  description = "Service account metadata"
  value       = kubernetes_service_account.github_actions_serviceaccount.metadata[0]
}

output "default_secret_name" {
  description = "Name of the Kubernetes secret containing the service account's credentials"
  value       = kubernetes_service_account.github_actions_serviceaccount.default_secret_name
}

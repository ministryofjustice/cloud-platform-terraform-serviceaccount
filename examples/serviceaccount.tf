module "serviceaccount" {
  source = "../"

  namespace           = "my-namespace"
  github_repositories = ["my-repo"]
  kubernetes_cluster  = "live-1"

  # list of github environments, to create the service account secrets as environment secrets
  # https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-secrets
  # github_environments = ["my-environment"]
}

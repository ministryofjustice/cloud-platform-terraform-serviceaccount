module "serviceaccount" {
  source = "../"

  namespace           = "my-namespace"
  github_repositories = ["my-repo"]
  kubernetes_cluster  = "live-1"

  # Pass the below variable to rotate your service account token. The token name will be appended with your rotation date, ie "cd-serviceaccount-token-01-01-2021"
  serviceaccount_token_rotated_date = "dd-mm-yyyy"

  # list of github environments, to create the service account secrets as environment secrets
  # https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-secrets
  # github_environments = ["my-environment"]
}

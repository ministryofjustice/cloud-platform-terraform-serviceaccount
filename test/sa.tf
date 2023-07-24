
module "sa" {
  source = "../"

  namespace           = "my-namespace"
  github_repositories = ["my-repo"]
  kubernetes_cluster  = "test-cluster"
  github_environments = ["my-environment"]

  serviceaccount_token_rotated_date = "01-01-2000"
}

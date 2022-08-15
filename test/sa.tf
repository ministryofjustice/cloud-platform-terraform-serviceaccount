
module "sa" {
  source = "../"

  namespace           = "my-namespace"
  github_repositories = ["my-repo"]
  kubernetes_cluster  = "test-cluster"
}

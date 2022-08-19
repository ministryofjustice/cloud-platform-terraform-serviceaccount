/*
 * When using this module through the cloud-platform-environments,
 * this variable is automatically supplied by the pipeline TF_VAR_kubernetes_cluster.
 *
*/
variable "kubernetes_cluster" {}
module "serviceaccount" {
  source = "../"

  namespace           = "my-namespace"
  github_repositories = ["my-repo"]

  # list of github environments, to create the service account secrets as environment secrets
  # https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-secrets
  # github_environments = ["my-environment"]
}

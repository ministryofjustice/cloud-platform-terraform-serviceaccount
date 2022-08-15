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

  # Enabling "enable_sa_env_secret" will create serviceaccount secrets as "Environment secrets"
  # https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-secrets
  enable_sa_env_secret   = true
}

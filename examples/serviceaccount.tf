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
}

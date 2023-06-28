/*
 * When using this module through the cloud-platform-environments,
 * this variable is automatically supplied by the pipeline TF_VAR_kubernetes_cluster.
 *
*/

variable "kubernetes_cluster" {}

variable "github_owner" {
  description = "Required by the github terraform provider"
  default     = "ministryofjustice"
}

variable "github_token" {
  description = "Required by the github terraform provider"
  default     = ""
}
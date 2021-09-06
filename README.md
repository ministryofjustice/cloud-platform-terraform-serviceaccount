# Kubernetes ServiceAccount module

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-serviceaccount/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-serviceaccount/releases)

This Terraform module will create a kubernetes serviceaccount, role and rolebinding in the specified namespace.

The default set of capabilities is usually sufficient for a CI/CD pipeline. These capabilities can be overridden by specifying the `serviceaccount_rules` variable (see `variables.tf` for details).

## GitHub Actions Secrets

If a list of GitHub repositories is supplied via the `github_repositories` variable, the following [GitHub Actions Secrets] will be created in those repositories:

| Default secret name | Description | Terraform variable to change the name |
|---------------------|-------------|---------------------------------------|
| `KUBE_CERT` | ServiceAccount `ca.crt` | `github_actions_secret_kube_cert` |
| `KUBE_TOKEN` | ServiceAccount `token` | `github_actions_secret_kube_token` |
| `KUBE_CLUSTER` | Cluster name | `github_actions_secret_kube_cluster` |
| `KUBE_NAMESPACE` | Namespace name | `github_actions_secret_kube_namespace` |

*Note* The terraform Github provider does not seem to trigger on changes in the parameters, but deleting the `serviceaccount` in the namespace will make it update the repo secrets too.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| namespace | The namespace in which to create the serviceaccount | string | | yes |
| serviceaccount_name | The name of the serviceaccount | string | cd-serviceaccount | no |
| role_name | The name of the created role | string | serviceaccount-role | no |
| rolebinding_name | The name of the created rolebinding | string | serviceaccount-rolebinding | no |
| github_repositories | GitHub repositories in which to create Github Actions Secrets | list(string) | [] | no |
| github_actions_secret_kube_cert | The name of the Github Actions Secret containing the `ca.crt` | string | KUBE_CERT | no |
| github_actions_secret_kube_token | The name of the Github Actions Secret containing the `token` | string | KUBE_TOKEN | no |
| github_actions_secret_kube_cluster | The name of the Github Actions Secret containing the kubernetes cluster name | string | KUBE_CLUSTER | no |
| github_actions_secret_kube_namespace | The name of the Github Actions Secret containing the namespace name | string | KUBE_NAMESPACE | no |
| serviceaccount_rules | The capabilities of the serviceaccount | list(object) | see `variables.tf` | no |

[Github Actions Secrets]: https://docs.github.com/en/actions/reference/encrypted-secrets

# Kubernetes ServiceAccount module

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-serviceaccount/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-serviceaccount/releases)

This Terraform module will create a kubernetes serviceaccount, role and rolebinding in the specified namespace.

The default set of capabilities is usually sufficient for a CI/CD pipeline. These capabilities can be overridden by specifying the `serviceaccount_rules` variable (see `variables.tf` for details).

## GitHub Actions Secrets

If a list of GitHub repositories is supplied via the `github_repositories` variable, [GitHub Actions Secrets] will be created in those repositories, containing the serviceaccount `ca.crt` and `token` values, for use in GitHub Actions CI/CD pipelines.

By default, these secrets are named `KUBE_CERT` and `KUBE_TOKEN`. The variables `github_actions_secret_kube_cert` and `github_actions_secret_kube_token` can be supplied to change these names.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| namespace | The namespace in which to create the serviceaccount | string | | yes |
| serviceaccount_name | The name of the serviceaccount | string | cd-serviceaccount | no |
| github_repositories | GitHub repositories in which to create Github Actions Secrets | list(string) | [] | no |
| github_actions_secret_kube_cert | The name of the Github Actions Secret containing the `ca.crt` | string | KUBE_CERT | no |
| github_actions_secret_kube_token | The name of the Github Actions Secret containing the `token` | string | KUBE_TOKEN | no |
| serviceaccount_rules | The capabilities of the serviceaccount | list(object) | see `variables.tf` | no |

[Github Actions Secrets]: https://docs.github.com/en/actions/reference/encrypted-secrets

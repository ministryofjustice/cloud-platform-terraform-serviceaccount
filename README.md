# Kubernetes ServiceAccount module

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-serviceaccount/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-serviceaccount/releases)

This Terraform module will create a kubernetes serviceaccount, role and rolebinding in the specified namespace.

The default set of capabilities is usually sufficient for a CI/CD pipeline. These capabilities can be overridden by specifying the `serviceaccount_rules` variable (see `variables.tf` for details).

## GitHub Actions Secrets

If a list of GitHub repositories is supplied via the `github_repositories` variable, the following [GitHub Actions Secrets] will be created in those repositories:

| Default secret name | Description             | Terraform variable to change the name  |
| ------------------- | ----------------------- | -------------------------------------- |
| `KUBE_CERT`         | ServiceAccount `ca.crt` | `github_actions_secret_kube_cert`      |
| `KUBE_TOKEN`        | ServiceAccount `token`  | `github_actions_secret_kube_token`     |
| `KUBE_CLUSTER`      | Cluster name            | `github_actions_secret_kube_cluster`   |
| `KUBE_NAMESPACE`    | Namespace name          | `github_actions_secret_kube_namespace` |

_Note_ The terraform Github provider does not seem to trigger on changes in the parameters, but deleting the `serviceaccount` in the namespace will make it update the repo secrets too.

[github actions secrets]: https://docs.github.com/en/actions/reference/encrypted-secrets

## Release

When making changes to this Terraform module you'll need to update the template file as it points to a specific version.

Update: `./template/serviceaccount.tmpl`


<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| irsa_vpc_cni | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.6.0 |

## Resources

| Name |
|------|
| [aws_eks_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addon\_coredns\_version | Version for addon\_coredns\_version | `string` | `"v1.8.4-eksbuild.1"` | no |
| addon\_create\_coredns | Create coredns addon | `bool` | `true` | no |
| addon\_create\_kube\_proxy | Create kube\_proxy addon | `bool` | `true` | no |
| addon\_create\_vpc\_cni | Create vpc\_cni addon | `bool` | `true` | no |
| addon\_kube\_proxy\_version | Version for addon\_kube\_proxy\_version | `string` | `"v1.21.2-eksbuild.2"` | no |
| addon\_tags | Cluster addon tags | `map(string)` | `{}` | no |
| addon\_vpc\_cni\_version | Version for addon\_create\_vpc\_cni | `string` | `"v1.9.3-eksbuild.1"` | no |
| cluster\_name | Kubernetes cluster name - used to name (id) the auth0 resources | `any` | n/a | yes |
| cluster\_oidc\_issuer\_url | Used to create the IAM OIDC role | `string` | `""` | no |
| eks\_cluster\_id | trigger for null resource using eks\_cluster\_id | `any` | n/a | yes |

## Outputs

No output.

<!--- END_TF_DOCS --->
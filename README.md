# Kubernetes ServiceAccount module

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-serviceaccount/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-serviceaccount/releases)

This Terraform module will create a kubernetes serviceaccount, role and rolebinding in the specified namespace.

The default set of capabilities is usually sufficient for a CI/CD pipeline. These capabilities can be overridden by specifying the `serviceaccount_rules` variable (see `variables.tf` for details).

## GitHub Actions Secrets

If a list of GitHub repositories is supplied via the `github_repositories` variable, the [GitHub Actions Secrets] below will be created in those repositories. If you need to specify a prefix for those variables (useful for multi-cluster applications), you can do so with the `env_prefix` variable:

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.cluster-name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.cluster-namespace](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.serviceaccount-cert](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.serviceaccount-token](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_secret.cluster-name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.cluster-namespace](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.serviceaccount-cert](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.serviceaccount-token](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [kubernetes_role.github_actions_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.github-actions-rolebinding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.github_actions_serviceaccount](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_secret.github_actions_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_actions_secret_kube_cert"></a> [github\_actions\_secret\_kube\_cert](#input\_github\_actions\_secret\_kube\_cert) | The name of the github actions secret containing the serviceaccount ca.crt | `string` | `"KUBE_CERT"` | no |
| <a name="input_github_actions_secret_kube_cluster"></a> [github\_actions\_secret\_kube\_cluster](#input\_github\_actions\_secret\_kube\_cluster) | The name of the github actions secret containing the kubernetes cluster name | `string` | `"KUBE_CLUSTER"` | no |
| <a name="input_github_actions_secret_kube_namespace"></a> [github\_actions\_secret\_kube\_namespace](#input\_github\_actions\_secret\_kube\_namespace) | The name of the github actions secret containing the kubernetes namespace name | `string` | `"KUBE_NAMESPACE"` | no |
| <a name="input_github_actions_secret_kube_token"></a> [github\_actions\_secret\_kube\_token](#input\_github\_actions\_secret\_kube\_token) | The name of the github actions secret containing the serviceaccount token | `string` | `"KUBE_TOKEN"` | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | GitHub environment in which to create github actions secrets | `list(string)` | `[]` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | GitHub repositories in which to create github actions secrets | `list(string)` | `[]` | no |
| <a name="input_kubernetes_cluster"></a> [kubernetes\_cluster](#input\_kubernetes\_cluster) | The name of the kubernetes cluster, for app. deployment | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace in which this serviceaccount will be created | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Kubernetes role name | `string` | `"serviceaccount-role"` | no |
| <a name="input_rolebinding_name"></a> [rolebinding\_name](#input\_rolebinding\_name) | Kubernetes to GitHub actions rolebinding name | `string` | `"serviceaccount-rolebinding"` | no |
| <a name="input_serviceaccount_name"></a> [serviceaccount\_name](#input\_serviceaccount\_name) | The name of the serviceaccount | `string` | `"cd-serviceaccount"` | no |
| <a name="input_serviceaccount_rules"></a> [serviceaccount\_rules](#input\_serviceaccount\_rules) | The capabilities of this serviceaccount | <pre>list(object({<br>    api_groups = list(string),<br>    resources  = list(string),<br>    verbs      = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "api_groups": [<br>      ""<br>    ],<br>    "resources": [<br>      "pods/portforward",<br>      "deployment",<br>      "secrets",<br>      "services",<br>      "configmaps",<br>      "pods"<br>    ],<br>    "verbs": [<br>      "patch",<br>      "get",<br>      "create",<br>      "update",<br>      "delete",<br>      "list",<br>      "watch"<br>    ]<br>  },<br>  {<br>    "api_groups": [<br>      "extensions",<br>      "apps",<br>      "batch",<br>      "networking.k8s.io",<br>      "policy"<br>    ],<br>    "resources": [<br>      "deployments",<br>      "ingresses",<br>      "cronjobs",<br>      "jobs",<br>      "replicasets",<br>      "poddisruptionbudgets"<br>    ],<br>    "verbs": [<br>      "get",<br>      "update",<br>      "delete",<br>      "create",<br>      "patch",<br>      "list",<br>      "watch"<br>    ]<br>  },<br>  {<br>    "api_groups": [<br>      "monitoring.coreos.com"<br>    ],<br>    "resources": [<br>      "prometheusrules"<br>    ],<br>    "verbs": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |

## Outputs

No outputs.

<!--- END_TF_DOCS --->

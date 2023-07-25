# istio

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_egress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_observability](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.istio_egress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_cluster_issuer_enabled"></a> [cert\_manager\_cluster\_issuer\_enabled](#input\_cert\_manager\_cluster\_issuer\_enabled) | Enable or disable the installation of LetsEncrypt Cluster issuer with istio Class | `bool` | `false` | no |
| <a name="input_cert_manager_letsencrypt_email"></a> [cert\_manager\_letsencrypt\_email](#input\_cert\_manager\_letsencrypt\_email) | Specifies the email address to be used by cert-manager to request Let's Encrypt certificates | `string` | n/a | yes |
| <a name="input_egress_gateway_enabled"></a> [egress\_gateway\_enabled](#input\_egress\_gateway\_enabled) | Enable or disable the installation of Istio Egress Gateway. | `bool` | `false` | no |
| <a name="input_egress_gateway_namespace"></a> [egress\_gateway\_namespace](#input\_egress\_gateway\_namespace) | Name of the Kubernetes namespace where the Istio Egress Gateway will be deployed. | `string` | `"istio-egressgateway"` | no |
| <a name="input_envoy_access_logs_enabled"></a> [envoy\_access\_logs\_enabled](#input\_envoy\_access\_logs\_enabled) | Enable or disable the installation of Envoy access logs across Mesh | `bool` | `false` | no |
| <a name="input_ingress_gateway_enabled"></a> [ingress\_gateway\_enabled](#input\_ingress\_gateway\_enabled) | Enable or disable the installation of Istio Ingress Gateway. | `bool` | `true` | no |
| <a name="input_ingress_gateway_namespace"></a> [ingress\_gateway\_namespace](#input\_ingress\_gateway\_namespace) | Name of the Kubernetes namespace where the Istio Ingress Gateway will be deployed | `string` | `"istio-ingressgateway"` | no |
| <a name="input_observability_enabled"></a> [observability\_enabled](#input\_observability\_enabled) | Enable or disable the installation of observability components | `bool` | `false` | no |
| <a name="input_prometheus_monitoring_enabled"></a> [prometheus\_monitoring\_enabled](#input\_prometheus\_monitoring\_enabled) | Enable or disable the installation of Prometheus Operator's servicemonitor to monitor Istio Controlplane and Dataplane | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

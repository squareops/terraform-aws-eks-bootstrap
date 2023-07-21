# karpenter_provisioner

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.karpenter_provisioner](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_excluded_karpenter_ec2_instance_type"></a> [excluded\_karpenter\_ec2\_instance\_type](#input\_excluded\_karpenter\_ec2\_instance\_type) | List of instance types that can be used by Karpenter | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_instance_hypervisor"></a> [instance\_hypervisor](#input\_instance\_hypervisor) | List of instance hypervisor that can be used by Karpenter | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | whether IPv6 enabled or not | `bool` | `false` | no |
| <a name="input_karpenter_ec2_capacity_type"></a> [karpenter\_ec2\_capacity\_type](#input\_karpenter\_ec2\_capacity\_type) | EC2 provisioning capacity type | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_sg_selector_name"></a> [sg\_selector\_name](#input\_sg\_selector\_name) | Name of security group selector for karpenter provisioner. | `string` | `""` | no |
| <a name="input_subnet_selector_name"></a> [subnet\_selector\_name](#input\_subnet\_selector\_name) | Name of subnet selector for karpenter provisioner. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

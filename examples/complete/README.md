# EKS Bootstrap
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
Terraform module to create EKS cluster addons for workload deployment on AWS Cloud.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.43.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_bootstrap"></a> [eks\_bootstrap](#module\_eks\_bootstrap) | squareops/eks-bootstrap/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_encryption_enable"></a> [ebs\_encryption\_enable](#output\_ebs\_encryption\_enable) | Is AWS EBS encryption is enabled or not? |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | EFS ID |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment Name for the EKS cluster |
| <a name="output_internal_nginx_ingress_controller_dns_hostname"></a> [internal\_nginx\_ingress\_controller\_dns\_hostname](#output\_internal\_nginx\_ingress\_controller\_dns\_hostname) | Internal NGINX Ingress Controller DNS Hostname |
| <a name="output_nginx_ingress_controller_dns_hostname"></a> [nginx\_ingress\_controller\_dns\_hostname](#output\_nginx\_ingress\_controller\_dns\_hostname) | NGINX Ingress Controller DNS Hostname |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

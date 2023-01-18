# EKS Bootstrap

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.23 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.6 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.13 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs"></a> [efs](#module\_efs) | ./addons/efs | n/a |
| <a name="module_external_secrets"></a> [external\_secrets](#module\_external\_secrets) | ./addons/external_secrets | n/a |
| <a name="module_istio"></a> [istio](#module\_istio) | ./addons/istio | n/a |
| <a name="module_k8s_addons"></a> [k8s\_addons](#module\_k8s\_addons) | github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons | v4.17.0 |
| <a name="module_karpenter_provisioner"></a> [karpenter\_provisioner](#module\_karpenter\_provisioner) | ./addons/karpenter_provisioner | n/a |
| <a name="module_service_monitor_crd"></a> [service\_monitor\_crd](#module\_service\_monitor\_crd) | ./addons/service_monitor_crd | n/a |
| <a name="module_single_az_sc"></a> [single\_az\_sc](#module\_single\_az\_sc) | ./addons/aws-ebs-storage-class | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ./addons/velero | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [helm_release.cert_manager_le_http](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [kubernetes_service.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_load_balancer_version"></a> [aws\_load\_balancer\_version](#input\_aws\_load\_balancer\_version) | load balancer version for ingress | `string` | `"1.4.4"` | no |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Set true to enable the cert manager for eks | `bool` | `false` | no |
| <a name="input_cert_manager_install_letsencrypt_http_issuers"></a> [cert\_manager\_install\_letsencrypt\_http\_issuers](#input\_cert\_manager\_install\_letsencrypt\_http\_issuers) | Set to true to install http issuer | `bool` | `false` | no |
| <a name="input_cert_manager_install_letsencrypt_r53_issuers"></a> [cert\_manager\_install\_letsencrypt\_r53\_issuers](#input\_cert\_manager\_install\_letsencrypt\_r53\_issuers) | Enable to create route53 issuer | `bool` | `false` | no |
| <a name="input_cert_manager_letsencrypt_email"></a> [cert\_manager\_letsencrypt\_email](#input\_cert\_manager\_letsencrypt\_email) | Enter cert manager email | `string` | `""` | no |
| <a name="input_cluster_autoscaler_chart_version"></a> [cluster\_autoscaler\_chart\_version](#input\_cluster\_autoscaler\_chart\_version) | Mention the version of the cluster autoscaler helm chart | `string` | `"9.19.1"` | no |
| <a name="input_create_efs_storage_class"></a> [create\_efs\_storage\_class](#input\_create\_efs\_storage\_class) | Set to true if you want to enable the EFS | `bool` | `false` | no |
| <a name="input_create_service_monitor_crd"></a> [create\_service\_monitor\_crd](#input\_create\_service\_monitor\_crd) | Set true to install CRDs for service monitor. | `bool` | `false` | no |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | Fetch Cluster ID of the cluster | `string` | `"stg-msa-reff"` | no |
| <a name="input_enable_amazon_eks_aws_ebs_csi_driver"></a> [enable\_amazon\_eks\_aws\_ebs\_csi\_driver](#input\_enable\_amazon\_eks\_aws\_ebs\_csi\_driver) | Enable EKS Managed AWS EBS CSI Driver add-on | `bool` | `false` | no |
| <a name="input_enable_amazon_eks_vpc_cni"></a> [enable\_amazon\_eks\_vpc\_cni](#input\_enable\_amazon\_eks\_vpc\_cni) | Set true to install VPC CNI addon. | `bool` | `false` | no |
| <a name="input_enable_aws_load_balancer_controller"></a> [enable\_aws\_load\_balancer\_controller](#input\_enable\_aws\_load\_balancer\_controller) | Enable AWS Load Balancer Controller add-on | `bool` | `false` | no |
| <a name="input_enable_aws_node_termination_handler"></a> [enable\_aws\_node\_termination\_handler](#input\_enable\_aws\_node\_termination\_handler) | Set it to true to Enable node termination handler | `bool` | `false` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | Enable Cluster autoscaler add-on | `bool` | `false` | no |
| <a name="input_enable_cluster_propotional_autoscaler"></a> [enable\_cluster\_propotional\_autoscaler](#input\_enable\_cluster\_propotional\_autoscaler) | Set true to Enable Cluster propotional autoscaler | `bool` | `false` | no |
| <a name="input_enable_external_secrets"></a> [enable\_external\_secrets](#input\_enable\_external\_secrets) | Enable External Secrets operator add-on | `bool` | `false` | no |
| <a name="input_enable_ingress_nginx"></a> [enable\_ingress\_nginx](#input\_enable\_ingress\_nginx) | Enable Ingress Nginx add-on | `bool` | `false` | no |
| <a name="input_enable_istio"></a> [enable\_istio](#input\_enable\_istio) | Enable istio for service mesh. | `bool` | `false` | no |
| <a name="input_enable_karpenter"></a> [enable\_karpenter](#input\_enable\_karpenter) | Set it to true to enable Karpenter | `bool` | `false` | no |
| <a name="input_enable_keda"></a> [enable\_keda](#input\_enable\_keda) | Enable KEDA Event-based autoscaler add-on | `bool` | `false` | no |
| <a name="input_enable_metrics_server"></a> [enable\_metrics\_server](#input\_enable\_metrics\_server) | Enable metrics server add-on | `bool` | `false` | no |
| <a name="input_enable_reloader"></a> [enable\_reloader](#input\_enable\_reloader) | Set true to enable reloader | `bool` | `false` | no |
| <a name="input_enable_single_az_ebs_gp3_storage_class"></a> [enable\_single\_az\_ebs\_gp3\_storage\_class](#input\_enable\_single\_az\_ebs\_gp3\_storage\_class) | Enable Single az storage class. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier for the EKS cluster | `string` | `"stg"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Specify the version of the nginx ingress | `string` | `"4.1.4"` | no |
| <a name="input_karpenter_ec2_capacity_type"></a> [karpenter\_ec2\_capacity\_type](#input\_karpenter\_ec2\_capacity\_type) | EC2 provisioning capacity type | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_karpenter_ec2_instance_type"></a> [karpenter\_ec2\_instance\_type](#input\_karpenter\_ec2\_instance\_type) | List of instance types that can be used by Karpenter | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_karpenter_node_iam_role"></a> [karpenter\_node\_iam\_role](#input\_karpenter\_node\_iam\_role) | Specify the IAM role for the nodes provision through karpenter. | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key to Encrypt AWS resources | `string` | `""` | no |
| <a name="input_kms_policy_arn"></a> [kms\_policy\_arn](#input\_kms\_policy\_arn) | Specify the ARN of KMS policy, for service accounts. | `string` | `""` | no |
| <a name="input_metrics_server_helm_version"></a> [metrics\_server\_helm\_version](#input\_metrics\_server\_helm\_version) | Mention the version of the metrics server helm chart | `string` | `"3.8.2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name prefix of the EKS cluster resources. | `string` | `"msa"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnets of the VPC which can be used by EFS | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_provider_url"></a> [provider\_url](#input\_provider\_url) | Provider URL of OIDC | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for the EKS cluster | `string` | `"us-east-2"` | no |
| <a name="input_sg_selector_name"></a> [sg\_selector\_name](#input\_sg\_selector\_name) | Name of security group selector for karpenter provisioner. | `string` | `""` | no |
| <a name="input_single_az_sc_config"></a> [single\_az\_sc\_config](#input\_single\_az\_sc\_config) | Define the Name and regions for storage class in Key-Value pair. | `list(any)` | `[]` | no |
| <a name="input_subnet_selector_name"></a> [subnet\_selector\_name](#input\_subnet\_selector\_name) | Name of subnet selector for karpenter provisioner. | `string` | `""` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | velero configurations | `any` | <pre>{<br>  "backup_bucket_name": "",<br>  "enable_velero": false,<br>  "namespaces": "",<br>  "retention_period_in_days": 45,<br>  "schedule_cron_time": "",<br>  "slack_channel_name": "",<br>  "slack_token": "",<br>  "velero_backup_name": ""<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster and its nodes will be provisioned | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_encryption"></a> [ebs\_encryption](#output\_ebs\_encryption) | Is AWS EBS encryption is enabled or not? |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | EFS ID |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment Name for the EKS cluster |
| <a name="output_nginx_ingress_controller_dns_hostname"></a> [nginx\_ingress\_controller\_dns\_hostname](#output\_nginx\_ingress\_controller\_dns\_hostname) | NGINX Ingress Controller DNS Hostname |
| <a name="output_region"></a> [region](#output\_region) | AWS Region for the EKS cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## IAM permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Policy required is:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteTags",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:CreateAccessPoint",
                "elasticfilesystem:CreateFileSystem",
                "elasticfilesystem:DeleteAccessPoint",
                "elasticfilesystem:DeleteFileSystem",
                "elasticfilesystem:DescribeAccessPoints",
                "elasticfilesystem:DescribeBackupPolicy",
                "elasticfilesystem:DescribeFileSystems",
                "elasticfilesystem:DescribeLifecycleConfiguration",
                "elasticfilesystem:DescribeMountTargets",
                "elasticfilesystem:PutBackupPolicy",
                "elasticfilesystem:TagResource",
                "elasticfilesystem:UntagResource"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "events:DeleteRule",
                "events:DescribeRule",
                "events:ListTagsForResource",
                "events:ListTargetsByRule",
                "events:PutRule",
                "events:PutTargets",
                "events:RemoveTargets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:CreatePolicy",
                "iam:CreateRole",
                "iam:DeleteInstanceProfile",
                "iam:DeletePolicy",
                "iam:DeleteRole",
                "iam:DetachRolePolicy",
                "iam:GetInstanceProfile",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:ListPolicyVersions",
                "iam:ListRolePolicies",
                "iam:PassRole",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:TagInstanceProfile",
                "iam:UntagInstanceProfile"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": [
                "kms:CreateGrant",
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:GenerateDataKey*",
                "kms:ReEncrypt*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor6",
            "Effect": "Allow",
            "Action": [
                "lambda:AddPermission",
                "lambda:CreateFunction",
                "lambda:DeleteFunction",
                "lambda:GetFunction",
                "lambda:GetFunctionCodeSigningConfig",
                "lambda:GetPolicy",
                "lambda:ListVersionsByFunction",
                "lambda:RemovePermission"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor7",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetChange",
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor8",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLogging",
                "s3:GetLifecycleConfiguration",
                "s3:PutBucketLogging",
                "s3:PutLifecycleConfiguration"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

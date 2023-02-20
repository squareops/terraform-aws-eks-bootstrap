## COMMON VARIABLES
variable "enable_amazon_eks_aws_ebs_csi_driver" {
  description = "Enable EKS Managed AWS EBS CSI Driver add-on"
  default     = false
  type        = bool
}

variable "enable_single_az_ebs_gp3_storage_class" {
  description = "Enable Single az storage class."
  default     = false
  type        = bool
}

variable "single_az_sc_config" {
  description = "Define the Name and regions for storage class in Key-Value pair."
  default     = []
  type        = list(any)
}

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster autoscaler add-on"
  default     = false
  type        = bool
}

variable "cluster_autoscaler_chart_version" {
  description = "Mention the version of the cluster autoscaler helm chart"
  default     = "9.19.1"
  type        = string
}

variable "enable_metrics_server" {
  description = "Enable metrics server add-on"
  default     = false
  type        = bool
}

variable "metrics_server_helm_version" {
  description = "Mention the version of the metrics server helm chart"
  default     = "3.8.2"
  type        = string
}

variable "cert_manager_enabled" {
  description = "Set true to enable the cert manager for eks"
  default     = false
  type        = bool
}

variable "cert_manager_install_letsencrypt_r53_issuers" {
  description = "Enable to create route53 issuer"
  default     = false
  type        = bool
}

variable "eks_cluster_name" {
  description = "Fetch Cluster ID of the cluster"
  default     = ""
  type        = string
}

variable "create_efs_storage_class" {
  description = "Set to true if you want to enable the EFS"
  default     = false
  type        = bool
}

variable "enable_keda" {
  description = "Enable KEDA Event-based autoscaler add-on"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = ""
  type        = string
}

variable "enable_external_secrets" {
  description = "Enable External Secrets operator add-on"
  default     = false
  type        = bool
}

variable "enable_ingress_nginx" {
  description = "Enable Ingress Nginx add-on"
  default     = false
  type        = bool
}

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  default     = false
  type        = bool
}

variable "aws_load_balancer_version" {
  description = "load balancer version for ingress"
  default     = "1.4.4"
  type        = string
}

variable "ingress_nginx_version" {
  description = "Specify the version of the nginx ingress"
  default     = "4.1.4"
  type        = string
}

variable "name" {
  description = "Specify the name prefix of the EKS cluster resources."
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  default     = ""
  type        = string
}
variable "private_subnet_ids" {
  description = "Private subnets of the VPC which can be used by EFS"
  default     = [""]
  type        = list(string)
}

variable "cert_manager_letsencrypt_email" {
  description = "Enter cert manager email"
  default     = ""
  type        = string
}

variable "cert_manager_install_letsencrypt_http_issuers" {
  description = "Set to true to install http issuer"
  default     = false
  type        = bool
}

variable "kms_key_arn" {
  description = "KMS key to Encrypt AWS resources"
  default     = ""
  type        = string
}

variable "kms_policy_arn" {
  description = "Specify the ARN of KMS policy, for service accounts."
  default     = ""
  type        = string
}

variable "provider_url" {
  description = "Provider URL of OIDC"
  default     = ""
  type        = string
}

variable "enable_cluster_propotional_autoscaler" {
  description = "Set true to Enable Cluster propotional autoscaler"
  default     = false
  type        = bool
}

variable "enable_karpenter" {
  description = "Set it to true to enable Karpenter"
  default     = false
  type        = bool
}

variable "enable_reloader" {
  description = "Set true to enable reloader"
  default     = false
  type        = bool
}

variable "worker_iam_role_name" {
  description = "Specify the IAM role for the nodes provision through karpenter."
  default     = ""
  type        = string
}

variable "enable_aws_node_termination_handler" {
  description = "Set it to true to Enable node termination handler"
  default     = false
  type        = bool
}

variable "enable_amazon_eks_vpc_cni" {
  description = "Set true to install VPC CNI addon."
  default     = false
  type        = bool
}

variable "create_service_monitor_crd" {
  description = "Set true to install CRDs for service monitor."
  default     = false
  type        = bool
}

variable "enable_istio" {
  description = "Enable istio for service mesh."
  default     = false
  type        = bool
}

variable "velero_config" {
  description = "velero configurations"
  default = {
    enable_velero            = false
    slack_token              = ""
    slack_channel_name       = ""
    retention_period_in_days = 45
    namespaces               = ""
    schedule_cron_time       = ""
    velero_backup_name       = ""
    backup_bucket_name       = ""
  }
  type = any
}

variable "private_subnet_name" {
  description = "Name of subnet selector for karpenter provisioner."
  default     = ""
  type        = string
}

/* variable "sg_selector_name" {
  description = "Name of security group selector for karpenter provisioner."
  default     = ""
  type        = string
} */

variable "karpenter_ec2_capacity_type" {
  description = "EC2 provisioning capacity type"
  default     = [""]
  type        = list(string)
}

variable "excluded_karpenter_ec2_instance_type" {
  description = "List of instance types that cannot be used by Karpenter"
  default     = [""]
  type        = list(string)
}

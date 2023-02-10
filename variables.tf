## COMMON VARIABLES
variable "enable_amazon_eks_aws_ebs_csi_driver" {
  description = "Enable EKS Managed AWS EBS CSI Driver add-on"
  type        = bool
  default     = false
}

variable "enable_single_az_ebs_gp3_storage_class" {
  type        = bool
  default     = false
  description = "Enable Single az storage class."
}

variable "single_az_sc_config" {
  type        = list(any)
  description = "Define the Name and regions for storage class in Key-Value pair."
  default     = []

}

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster autoscaler add-on"
  type        = bool
  default     = false
}

variable "cluster_autoscaler_chart_version" {
  description = "Mention the version of the cluster autoscaler helm chart"
  default     = "9.19.1"
  type        = string
}

variable "enable_metrics_server" {
  description = "Enable metrics server add-on"
  type        = bool
  default     = false
}

variable "metrics_server_helm_version" {
  type        = string
  default     = "3.8.2"
  description = "Mention the version of the metrics server helm chart"
}

variable "cert_manager_enabled" {
  description = "Set true to enable the cert manager for eks"
  default     = false
  type        = bool
}

variable "cert_manager_install_letsencrypt_r53_issuers" {
  type        = bool
  default     = false
  description = "Enable to create route53 issuer"
}

variable "eks_cluster_id" {
  description = "Fetch Cluster ID of the cluster"
  default     = "stg-msa-reff"
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
  default     = "stg"
  type        = string
}

variable "enable_external_secrets" {
  type        = bool
  default     = false
  description = "Enable External Secrets operator add-on"
}


variable "enable_ingress_nginx" {
  description = "Enable Ingress Nginx add-on"
  type        = bool
  default     = false
}

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  type        = bool
  default     = false
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
  default     = "msa"
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
  default     = ""
  type        = string
  description = "Enter cert manager email"
}

variable "cert_manager_install_letsencrypt_http_issuers" {
  type        = bool
  default     = false
  description = "Set to true to install http issuer"
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "KMS key to Encrypt AWS resources"
}

variable "kms_policy_arn" {
  type        = string
  default     = ""
  description = "Specify the ARN of KMS policy, for service accounts."
}

variable "provider_url" {
  description = "Provider URL of OIDC"
  default     = ""
  type        = string
}

variable "enable_cluster_propotional_autoscaler" {
  type        = bool
  description = "Set true to Enable Cluster propotional autoscaler"
  default     = false
}

variable "enable_karpenter" {
  type        = bool
  description = "Set it to true to enable Karpenter"
  default     = false
}

variable "enable_reloader" {
  type        = bool
  description = "Set true to enable reloader"
  default     = false
}

variable "karpenter_node_iam_role" {
  type        = string
  description = "Specify the IAM role for the nodes provision through karpenter."
}

variable "enable_aws_node_termination_handler" {
  type        = bool
  description = "Set it to true to Enable node termination handler"
  default     = false
}

variable "enable_amazon_eks_vpc_cni" {
  type        = bool
  default     = false
  description = "Set true to install VPC CNI addon."
}

variable "create_service_monitor_crd" {
  type        = bool
  default     = false
  description = "Set true to install CRDs for service monitor."
}

variable "enable_istio" {
  description = "Enable istio for service mesh."
  type        = bool
  default     = false
}

variable "velero_config" {
  description = "velero configurations"
  type        = any
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
}

variable "subnet_selector_name" {
  description = "Name of subnet selector for karpenter provisioner."
  type        = string
  default     = ""
}

variable "sg_selector_name" {
  description = "Name of security group selector for karpenter provisioner."
  type        = string
  default     = ""
}

variable "karpenter_ec2_capacity_type" {
  description = "EC2 provisioning capacity type"
  type        = list(string)
  default     = [""]
}

variable "excluded_karpenter_ec2_instance_type" {
  description = "List of instance types that cannot be used by Karpenter"
  type        = list(string)
  default     = [""]
}

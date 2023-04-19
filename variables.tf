## COMMON VARIABLES
variable "amazon_eks_aws_ebs_csi_driver_enabled" {
  description = "Enable EKS Managed AWS EBS CSI Driver add-on"
  default     = false
  type        = bool
}

variable "single_az_ebs_gp3_storage_class_enabled" {
  description = "Enable Single az storage class."
  default     = false
  type        = bool
}

variable "single_az_sc_config" {
  description = "Define the Name and regions for storage class in Key-Value pair."
  default     = []
  type        = list(any)
}

variable "cluster_autoscaler_enabled" {
  description = "Enable Cluster autoscaler add-on"
  default     = false
  type        = bool
}

variable "cluster_autoscaler_chart_version" {
  description = "Mention the version of the cluster autoscaler helm chart"
  default     = "9.19.1"
  type        = string
}

variable "metrics_server_enabled" {
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

variable "efs_storage_class_enabled" {
  description = "Set to true if you want to enable the EFS"
  default     = false
  type        = bool
}

variable "keda_enabled" {
  description = "Enable KEDA Event-based autoscaler add-on"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = ""
  type        = string
}

variable "external_secrets_enabled" {
  description = "Enable External Secrets operator add-on"
  default     = false
  type        = bool
}

variable "ingress_nginx_enabled" {
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

variable "cluster_propotional_autoscaler_enabled" {
  description = "Set true to Enable Cluster propotional autoscaler"
  default     = false
  type        = bool
}

variable "karpenter_enabled" {
  description = "Set it to true to enable Karpenter"
  default     = false
  type        = bool
}

variable "reloader_enabled" {
  description = "Set true to enable reloader"
  default     = false
  type        = bool
}

variable "worker_iam_role_name" {
  description = "Specify the IAM role for the nodes that will be provisioned through karpenter"
  default     = ""
  type        = string
}

variable "aws_node_termination_handler_enabled" {
  description = "Set it to true to Enable node termination handler"
  default     = false
  type        = bool
}

variable "amazon_eks_vpc_cni_enabled" {
  description = "Set true to install VPC CNI addon."
  default     = false
  type        = bool
}

variable "service_monitor_crd_enabled" {
  description = "Set true to install CRDs for service monitor."
  default     = false
  type        = bool
}

variable "istio_enabled" {
  description = "Enable istio for service mesh."
  default     = false
  type        = bool
}

variable "velero_enabled" {
  description = "Enable velero for eks cluster backup"
  default     = false
  type        = bool
}
variable "velero_config" {
  description = "velero configurations"
  default = {
    namespaces                      = "" ## If you want full cluster backup, leave it blank else provide namespace.
    slack_notification_token        = ""
    slack_notification_channel_name = ""
    retention_period_in_days        = 45
    schedule_backup_cron_time       = ""
    velero_backup_name              = ""
    backup_bucket_name              = ""
  }
  type = any
}

variable "karpenter_provisioner_enabled" {
  description = "Enable karpenter provisioner"
  default     = false
  type        = bool
}
variable "karpenter_provisioner_config" {
  description = "karpenter provisioner configuration"
  default = {
    private_subnet_name    = ""
    instance_capacity_type = ["spot"]
    excluded_instance_type = ["nano", "micro", "small"]
  }
  type = any
}

variable "internal_ingress_nginx_enabled" {
  description = "Set it to true to deploy internal ingress controller"
  default     = false
  type        = bool
}

variable "node_termination_handler_version" {
  description = "Specify the version of node termination handler"
  default     = "0.21.0"
  type        = string
}

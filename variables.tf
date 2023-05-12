## COMMON VARIABLES
variable "amazon_eks_aws_ebs_csi_driver_enabled" {
  description = "Whether to enable the EKS Managed AWS EBS CSI Driver add-on or not."
  default     = false
  type        = bool
}

variable "single_az_ebs_gp3_storage_class_enabled" {
  description = "Whether to enable the Single AZ storage class or not."
  default     = false
  type        = bool
}

variable "single_az_sc_config" {
  description = "Name and regions for storage class in Key-Value pair."
  default     = []
  type        = list(any)
}

variable "cluster_autoscaler_enabled" {
  description = "Whether to enable the Cluster Autoscaler add-on or not."
  default     = false
  type        = bool
}

variable "cluster_autoscaler_chart_version" {
  description = "Version of the cluster autoscaler helm chart"
  default     = "9.19.1"
  type        = string
}

variable "metrics_server_enabled" {
  description = "Enable or disable the metrics server add-on for EKS cluster."
  default     = false
  type        = bool
}

variable "metrics_server_helm_version" {
  description = "Version of the metrics server helm chart"
  default     = "3.8.2"
  type        = string
}

variable "cert_manager_enabled" {
  description = "Enable or disable the cert manager add-on for EKS cluster."
  default     = false
  type        = bool
}

variable "cert_manager_install_letsencrypt_r53_issuers" {
  description = "Enable or disable the creation of Route53 issuer while installing cert manager."
  default     = false
  type        = bool
}

variable "eks_cluster_name" {
  description = "Fetch Cluster ID of the cluster"
  default     = ""
  type        = string
}

variable "efs_storage_class_enabled" {
  description = "Enable or disable the Amazon Elastic File System (EFS) add-on for EKS cluster."
  default     = false
  type        = bool
}

variable "keda_enabled" {
  description = "Enable or disable Kubernetes Event-driven Autoscaling (KEDA) add-on for autoscaling workloads."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment identifier for the Amazon Elastic Kubernetes Service (EKS) cluster."
  default     = ""
  type        = string
}

variable "external_secrets_enabled" {
  description = "Enable or disable External Secrets operator add-on for managing external secrets."
  default     = false
  type        = bool
}

variable "ingress_nginx_enabled" {
  description = "Enable or disable Nginx Ingress Controller add-on for routing external traffic to Kubernetes services."
  default     = false
  type        = bool
}

variable "enable_aws_load_balancer_controller" {
  description = "Enable or disable AWS Load Balancer Controller add-on for managing and controlling load balancers in Kubernetes."
  default     = false
  type        = bool
}

variable "aws_load_balancer_version" {
  description = "Specify the version of the AWS Load Balancer Controller for Ingress"
  default     = "1.4.4"
  type        = string
}

variable "ingress_nginx_version" {
  description = "Specify the version of the NGINX Ingress Controller"
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
  description = "Specifies the email address to be used by cert-manager to request Let's Encrypt certificates"
  default     = ""
  type        = string
}

variable "cert_manager_install_letsencrypt_http_issuers" {
  description = "Enable or disable the HTTP issuer for cert-manager"
  default     = false
  type        = bool
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt AWS resources in the EKS cluster."
  default     = ""
  type        = string
}

variable "kms_policy_arn" {
  description = "Specify the ARN of KMS policy, for service accounts."
  default     = ""
  type        = string
}

variable "cluster_propotional_autoscaler_enabled" {
  description = "Enable or disable Cluster propotional autoscaler add-on"
  default     = false
  type        = bool
}

variable "karpenter_enabled" {
  description = "Enable or disable Karpenter, a Kubernetes-native, multi-tenant, and auto-scaling solution for containerized workloads on Kubernetes."
  default     = false
  type        = bool
}

variable "reloader_enabled" {
  description = "Enable or disable Reloader, a Kubernetes controller to watch changes in ConfigMap and Secret objects and trigger an application reload on their changes."
  default     = false
  type        = bool
}

variable "worker_iam_role_name" {
  description = "Specify the IAM role for the nodes that will be provisioned through karpenter"
  default     = ""
  type        = string
}

variable "aws_node_termination_handler_enabled" {
  description = "Enable or disable node termination handler"
  default     = false
  type        = bool
}

variable "amazon_eks_vpc_cni_enabled" {
  description = "Enable or disable the installation of the Amazon EKS VPC CNI addon. "
  default     = false
  type        = bool
}

variable "service_monitor_crd_enabled" {
  description = "Enable or disable the installation of Custom Resource Definitions (CRDs) for Prometheus Service Monitor. "
  default     = false
  type        = bool
}

variable "istio_enabled" {
  description = "Enable istio for service mesh."
  default     = false
  type        = bool
}

variable "velero_enabled" {
  description = "Enable or disable the installation of Velero, which is a backup and restore solution for Kubernetes clusters."
  default     = false
  type        = bool
}
variable "velero_config" {
  description = "Configuration to provide settings for Velero, including which namespaces to backup, retention period, backup schedule, and backup bucket name."
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
  description = "Enable or disable the installation of Karpenter, which is a Kubernetes cluster autoscaler."
  default     = false
  type        = bool
}
variable "karpenter_provisioner_config" {
  description = "Configuration to provide settings for Karpenter, including which private subnet to use, instance capacity types, and excluded instance types."
  default = {
    private_subnet_name    = ""
    instance_capacity_type = ["spot"]
    excluded_instance_type = ["nano", "micro", "small"]
  }
  type = any
}

variable "internal_ingress_nginx_enabled" {
  description = "Enable or disable the deployment of an internal ingress controller for Kubernetes."
  default     = false
  type        = bool
}

variable "node_termination_handler_version" {
  description = "Specify the version of node termination handler"
  default     = "0.21.0"
  type        = string
}

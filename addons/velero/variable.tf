variable "name" {
  description = "Specify the name prefix of the EKS cluster resources."
  type        = string
  default     = ""
}

variable "cluster_id" {
  description = "Provide name of cluster to take backup."
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region for the EKS cluster"
  default     = "us-east-2"
  type        = string
}

variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = ""
  type        = string
}

variable "velero_config" {
  description = "velero configurations"
  type        = any
  default = {
    slack_token              = ""
    slack_channel_name       = ""
    retention_period_in_days = 45
    namespaces               = ""
    schedule_cron_time       = ""
    velero_backup_name       = ""
    backup_bucket_name       = ""
  }
}

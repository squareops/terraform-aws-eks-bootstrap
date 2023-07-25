variable "cluster_id" {
  description = "Fetch Cluster ID of the cluster"
  default     = ""
  type        = string
}

variable "create_efs_security_group" {
  description = "Define if you want to create the security group for EFS"
  default     = false
  type        = bool
}

variable "region" {
  description = "AWS region for the EKS cluster"
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  default     = ""
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets of the VPC which can be used by EKS"
  default     = [""]
  type        = list(string)
}

variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = ""
  type        = string
}

variable "name" {
  description = "Specify the name of the EKS cluster"
  default     = ""
  type        = string
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "Specify the KMS key ID"
}

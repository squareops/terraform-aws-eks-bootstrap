variable "cluster_id" {
  default     = ""
  type        = string
  description = "Fetch ID of the cluster"
}

variable "environment" {
  default     = ""
  type        = string
  description = "Environment identifier for the EKS cluster"
}

variable "name" {
  default     = ""
  type        = string
  description = "Specify the name of the resource"
}

variable "provider_url" {
  default = ""
  type    = string
}

variable "region" {
  default     = ""
  type        = string
  description = "AWS region for the EKS cluster"
}

variable "enable_service_monitor" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

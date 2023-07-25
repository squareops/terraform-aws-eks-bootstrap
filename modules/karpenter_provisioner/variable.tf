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
  description = "List of instance types that can be used by Karpenter"
  type        = list(string)
  default     = [""]
}

variable "instance_hypervisor" {
  description = "List of instance hypervisor that can be used by Karpenter"
  type        = list(string)
  default     = [""]
}

variable "ipv6_enabled" {
  description = "whether IPv6 enabled or not"
  type        = bool
  default     = false
}

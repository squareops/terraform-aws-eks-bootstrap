output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = local.environment
}

output "nginx_ingress_controller_dns_hostname" {
  description = "NGINX Ingress Controller DNS Hostname"
  value       = module.eks_bootstrap.nginx_ingress_controller_dns_hostname
}

output "ebs_encryption_enable" {
  description = "Is AWS EBS encryption is enabled or not?"
  value       = "Encrypted by default"
}

output "efs_id" {
  value       = module.eks_bootstrap.efs_id
  description = "EFS ID"
}

output "internal_nginx_ingress_controller_dns_hostname" {
  description = "Internal NGINX Ingress Controller DNS Hostname"
  value       = module.eks_bootstrap.internal_nginx_ingress_controller_dns_hostname
}

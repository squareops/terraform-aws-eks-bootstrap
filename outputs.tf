output "region" {
  description = "AWS Region for the EKS cluster"
  value       = var.region
}

output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = var.environment
}

output "nginx_ingress_controller_dns_hostname" {
  description = "NGINX Ingress Controller DNS Hostname"
  value       = data.kubernetes_service.nginx-ingress.status[0].load_balancer[0].ingress[0].hostname
}

output "ebs_encryption" {
  description = "Is AWS EBS encryption is enabled or not?"
  value       = "Encrypted by default"
}

output "efs_id" {
  value       = module.efs.*.efs_id
  description = "EFS ID"
}

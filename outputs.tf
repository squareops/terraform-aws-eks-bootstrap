output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = var.environment
}

output "nginx_ingress_controller_dns_hostname" {
  description = "NGINX Ingress Controller DNS Hostname"
  value       = data.kubernetes_service.nginx-ingress.status[0].load_balancer[0].ingress[0].hostname
}

output "ebs_encryption_enable" {
  description = "Is AWS EBS encryption is enabled or not?"
  value       = "Encrypted by default"
}

output "efs_id" {
  description = "EFS ID"
  value       = module.efs.*.efs_id
}

output "internal_nginx_ingress_controller_dns_hostname" {
  description = "Internal NGINX Ingress Controller DNS Hostname"
  value       = var.internal_ingress_nginx_enabled ? data.kubernetes_service.internal-nginx-ingress.status[0].load_balancer[0].ingress[0].hostname : null
}

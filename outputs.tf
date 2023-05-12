output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = var.environment
}

output "nginx_ingress_controller_dns_hostname" {
  description = "DNS hostname of the NGINX Ingress Controller."
  value       = data.kubernetes_service.nginx-ingress.status[0].load_balancer[0].ingress[0].hostname
}

output "ebs_encryption_enable" {
  description = "Whether Amazon Elastic Block Store (EBS) encryption is enabled or not."
  value       = "Encrypted by default"
}

output "efs_id" {
  value       = module.efs.*.efs_id
  description = "ID of the Amazon Elastic File System (EFS) that has been created for the EKS cluster."
}

output "internal_nginx_ingress_controller_dns_hostname" {
  description = "DNS hostname of the NGINX Ingress Controller that can be used to access it from within the cluster."
  value       = var.internal_ingress_nginx_enabled ? data.kubernetes_service.internal-nginx-ingress.status[0].load_balancer[0].ingress[0].hostname : null
}

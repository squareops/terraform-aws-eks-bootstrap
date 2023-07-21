output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = local.environment
}

output "nginx_ingress_controller_dns_hostname" {
  description = "DNS hostname of the NGINX Ingress Controller."
  value       = module.eks_bootstrap.nginx_ingress_controller_dns_hostname
}

output "ebs_encryption_enable" {
  description = "Whether Amazon Elastic Block Store (EBS) encryption is enabled or not."
  value       = "Encrypted by default"
}

output "efs_id" {
  value       = module.eks_bootstrap.efs_id
  description = "ID of the Amazon Elastic File System (EFS) that has been created for the EKS cluster."
}

output "internal_nginx_ingress_controller_dns_hostname" {
  description = "DNS hostname of the NGINX Ingress Controller that can be used to access it from within the cluster."
  value       = module.eks_bootstrap.internal_nginx_ingress_controller_dns_hostname
}

output "kubeclarity" {
  value       = module.eks_bootstrap.kubeclarity
  description = "Hostname for the kubeclarity."
}

output "kubecost" {
  value       = module.eks_bootstrap.kubecost
  description = "Hostname for the kubecost."
}

output "istio_ingressgateway_dns_hostname" {
  value       = module.eks_bootstrap.istio_ingressgateway_dns_hostname
  description = "DNS hostname of the Istio Ingress Gateway"
}

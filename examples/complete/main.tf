locals {
  region      = "us-east-2"
  environment = "prod"
  name        = "addons"
  additional_tags = {
    Owner      = "SquareOps"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "eks_bootstrap" {
  source                        = "squareops/eks-bootstrap/aws"
  name                          = local.name
  vpc_id                        = ""
  environment                   = local.environment
  kms_key_arn                   = ""
  keda_enabled                  = true
  istio_enabled                 = false
  kms_policy_arn                = "" ## eks module will create kms_policy_arn
  eks_cluster_name              = ""
  reloader_enabled              = true
  karpenter_enabled             = true
  single_az_sc_config           = [{ name = "infra-service-sc", zone = "us-east-2a" }]
  kubeclarity_enabled           = false
  kubeclarity_hostname          = ""
  enable_kubecost               = false
  kubecost_hostname             = ""
  cert_manager_enabled          = true
  worker_iam_role_name          = ""
  ingress_nginx_enabled         = true
  metrics_server_enabled        = false
  external_secrets_enabled      = true
  amazon_eks_vpc_cni_enabled    = true
  cluster_autoscaler_enabled    = true
  service_monitor_crd_enabled   = true
  karpenter_provisioner_enabled = false
  karpenter_provisioner_config = {
    private_subnet_name    = "private-subnet-name"
    instance_capacity_type = ["on-demand"]
    excluded_instance_type = ["nano", "micro", "small"]
  }
  cert_manager_letsencrypt_email                = "email@email.com"
  internal_ingress_nginx_enabled                = true
  efs_storage_class_enabled                     = true
  aws_node_termination_handler_enabled          = true
  amazon_eks_aws_ebs_csi_driver_enabled         = true
  cluster_propotional_autoscaler_enabled        = true
  single_az_ebs_gp3_storage_class_enabled       = true
  cert_manager_install_letsencrypt_http_issuers = true
  velero_enabled                                = true
  velero_config = {
    namespaces                      = "" ## If you want full cluster backup, leave it blank else provide namespace.
    slack_notification_token        = "xoxb-EuvmxrYxRatsM8R"
    slack_notification_channel_name = ""
    retention_period_in_days        = 45
    schedule_backup_cron_time       = ""
    velero_backup_name              = ""
    backup_bucket_name              = ""
  }
}

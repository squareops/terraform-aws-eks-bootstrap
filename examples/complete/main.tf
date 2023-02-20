locals {
  region      = "us-east-2"
  environment = "production"
  name        = "skaf"
  additional_tags = {
    Owner      = "SquareOps"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "eks_bootstrap" {
  source                                        = "squareops/eks-bootstrap/aws"
  environment                                   = local.environment
  name                                          = local.name
  eks_cluster_name                              = "prod-skaf"
  single_az_sc_config                           = [{ name = "infra-service-sc", zone = "us-east-2a" }]
  kms_key_arn                                   = ""
  kms_policy_arn                                = ""
  cert_manager_letsencrypt_email                = "email@example.com"
  vpc_id                                        = ""
  private_subnet_ids                            = []
  provider_url                                  = ""
  enable_single_az_ebs_gp3_storage_class        = true
  enable_amazon_eks_aws_ebs_csi_driver          = true
  enable_amazon_eks_vpc_cni                     = true
  create_service_monitor_crd                    = true
  enable_cluster_autoscaler                     = true
  enable_cluster_propotional_autoscaler         = true
  enable_reloader                               = true
  enable_metrics_server                         = true
  enable_ingress_nginx                          = true
  cert_manager_enabled                          = true
  cert_manager_install_letsencrypt_http_issuers = true
  enable_external_secrets                       = true
  enable_keda                                   = true
  create_efs_storage_class                      = true
  enable_istio                                  = false
  enable_karpenter                              = true
  enable_aws_node_termination_handler           = true
  worker_iam_role_name                          = ""
  private_subnet_name                           = ""
  karpenter_ec2_capacity_type                   = ["spot"]
  excluded_karpenter_ec2_instance_type          = ["nano", "micro", "small"]
  velero_config = {
    enable_velero            = false
    slack_token              = ""
    slack_channel_name       = ""
    retention_period_in_days = 45
    namespaces               = ""
    schedule_cron_time       = ""
    velero_backup_name       = ""
    backup_bucket_name       = ""
  }
}

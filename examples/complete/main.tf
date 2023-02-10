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
  source                                        = "../../"
  environment                                   = local.environment
  name                                          = local.name
  eks_cluster_id                                = ""
  enable_amazon_eks_aws_ebs_csi_driver          = true
  kms_policy_arn                                = ""
  enable_single_az_ebs_gp3_storage_class        = true
  single_az_sc_config                           = [{ name = "infra-service-sc", zone = "us-east-2a" }]
  kms_key_id                                    = ""
  enable_amazon_eks_vpc_cni                     = true
  create_service_monitor_crd                    = true
  enable_cluster_autoscaler                     = true
  enable_cluster_propotional_autoscaler         = true
  enable_reloader                               = true
  enable_metrics_server                         = false
  enable_ingress_nginx                          = true
  cert_manager_enabled                          = true
  cert_manager_install_letsencrypt_http_issuers = true
  cert_manager_letsencrypt_email                = "skaf-demo@squareops.com"
  enable_external_secrets                       = true
  provider_url                                  = ""
  enable_keda                                   = true
  create_efs_storage_class                      = true
  vpc_id                                        = ""
  private_subnet_ids                            = []
  enable_istio                                  = false
  enable_karpenter                              = true
  karpenter_node_iam_role                       = ""
  enable_aws_node_termination_handler           = true
  subnet_selector_name= ""
  sg_selector_name= ""
  karpenter_ec2_capacity_type= ["spot"]
  karpenter_ec2_instance_type= ["nano", "micro", "small"]
  velero_config = {
    enable_velero = true
    slack_token = ""
    slack_channel_name = ""
    retention_period_in_days = 45
    namespaces = ""
    schedule_cron_time = ""
    velero_backup_name = ""
    backup_bucket_name = ""

  }
}


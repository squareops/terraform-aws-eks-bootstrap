data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_id
}

### Service Monitor CRDs
module "service_monitor_crd" {
  source = "./addons/service_monitor_crd"
}

resource "aws_iam_instance_profile" "karpenter_profile" {
  role        = var.karpenter_node_iam_role
  name_prefix = var.eks_cluster_id

  tags = merge(
    { "Name"        = format("%s-%s-karpenter-profile", var.environment, var.name)
      "Environment" = var.environment
    }
  )
}

module "k8s_addons" {
  depends_on     = [module.service_monitor_crd]
  source         = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.17.0"
  eks_cluster_id = var.eks_cluster_id
  #ebs csi driver
  enable_amazon_eks_aws_ebs_csi_driver = var.enable_amazon_eks_aws_ebs_csi_driver
  amazon_eks_aws_ebs_csi_driver_config = {
    additional_iam_policies = [var.kms_policy_arn]
  }
  #cluster-autoscaler
  enable_cluster_autoscaler = var.enable_cluster_autoscaler
  cluster_autoscaler_helm_config = {
    version = var.cluster_autoscaler_chart_version
    values = [templatefile("${path.module}/addons/cluster_autoscaler/cluster_autoscaler.yaml", {
      aws_region     = var.region
      eks_cluster_id = var.eks_cluster_id
    })]
  }
  #metrics server
  enable_metrics_server = var.enable_metrics_server
  metrics_server_helm_config = {
    version = var.metrics_server_helm_version
    values  = [file("${path.module}/addons/metrics_server/metrics_server.yaml")]
  }
  #keda
  enable_keda = var.enable_keda
  #Ingress Nginx Controller
  enable_ingress_nginx = var.enable_ingress_nginx
  ingress_nginx_helm_config = {
    version = var.ingress_nginx_version
    values = [
      templatefile("${path.module}/addons/nginx_ingress/nginx_ingress.yaml", {
        enable_service_monitor = var.create_service_monitor_crd

      })
    ]
  }
  #Cert Manager
  cert_manager_install_letsencrypt_issuers = var.cert_manager_install_letsencrypt_r53_issuers
  cert_manager_letsencrypt_email           = var.cert_manager_letsencrypt_email
  enable_cert_manager                      = var.cert_manager_enabled
  cert_manager_helm_config = {
    values = [
      file("${path.module}/addons/cert_manager/cert_manager.yaml")
    ]
  }
  #Aws Load balancer Controller
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller_helm_config = {
    version = var.aws_load_balancer_version
    values = [
      file("${path.module}/addons/aws_alb/aws_alb.yaml")
    ]
  }

  enable_coredns_autoscaler = var.enable_cluster_propotional_autoscaler
  coredns_autoscaler_helm_config = {
    values = [
      file("${path.module}/addons/cluster_propotional_autoscaler/cpa.yaml")
    ]
  }

  enable_karpenter = var.enable_karpenter
  karpenter_helm_config = {
    values = [
      templatefile("${path.module}/addons/karpenter/karpenter.yaml", {
        eks_cluster_id            = var.eks_cluster_id,
        node_iam_instance_profile = aws_iam_instance_profile.karpenter_profile.name
        eks_cluster_endpoint      = data.aws_eks_cluster.eks.endpoint
      })
    ]
  }
  karpenter_node_iam_instance_profile = aws_iam_instance_profile.karpenter_profile.name

  enable_reloader = var.enable_reloader
  reloader_helm_config = {
    values = [
      templatefile("${path.module}/addons/reloader/reloader.yaml", {
        enable_service_monitor = var.create_service_monitor_crd
      })
    ]
    namespace        = "kube-system"
    create_namespace = false
  }

  enable_aws_node_termination_handler = var.enable_aws_node_termination_handler
  aws_node_termination_handler_helm_config = {
    values = [
      templatefile("${path.module}/addons/aws_node_termination_handler/aws_nth.yaml", {
        enable_service_monitor = var.create_service_monitor_crd
      })
    ]
  }

  enable_amazon_eks_vpc_cni        = var.enable_amazon_eks_vpc_cni
  enable_aws_efs_csi_driver        = var.create_efs_storage_class
  aws_efs_csi_driver_irsa_policies = [var.kms_policy_arn]
}

resource "helm_release" "cert_manager_le_http" {
  count      = var.cert_manager_install_letsencrypt_http_issuers ? 1 : 0
  depends_on = [module.k8s_addons]
  name       = "cert-manager-le-http"
  chart      = "${path.module}/addons/cert-manager-le-http"
  version    = "0.1.0"

  set {
    name  = "email"
    value = var.cert_manager_letsencrypt_email
    type  = "string"
  }
}

# OPEN: Default label needs to be removed from gp2 storageclass in order to make gp3 as default choice for EBS volume provisioning.
module "single_az_sc" {
  for_each                             = { for sc in var.single_az_sc_config : sc.name => sc }
  source                               = "./addons/aws-ebs-storage-class"
  single_az_ebs_gp3_storage_class      = var.enable_single_az_ebs_gp3_storage_class
  single_az_ebs_gp3_storage_class_name = each.value.name
  kms_key_id                           = var.kms_key_id
  availability_zone                    = each.value.zone
}

module "external_secrets" {
  depends_on = [module.service_monitor_crd]
  source     = "./addons/external_secrets"
  count      = var.enable_external_secrets ? 1 : 0

  provider_url           = var.provider_url
  cluster_id             = var.eks_cluster_id
  environment            = var.environment
  region                 = var.region
  name                   = var.name
  enable_service_monitor = var.create_service_monitor_crd

}

### EFS
module "efs" {
  source             = "./addons/efs"
  depends_on         = [module.k8s_addons]
  count              = var.create_efs_storage_class ? 1 : 0
  environment        = var.environment
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  region             = var.region
  name               = var.name
  kms_key_id         = var.kms_key_id
}

data "kubernetes_service" "nginx-ingress" {
  depends_on = [module.k8s_addons]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

module "velero" {
  source        = "./addons/velero"
  count         = var.velero_config.enable_velero ? 1 : 0
  name          = var.name
  cluster_id    = var.eks_cluster_id
  environment   = var.environment
  region        = var.region
  velero_config = var.velero_config

}

module "istio" {
  source = "./addons/istio"
  count  = var.enable_istio ? 1 : 0


}

module "karpenter_provisioner" {
  source                      = "./addons/karpenter_provisioner"
  depends_on                  = [module.k8s_addons]
  count                       = var.enable_karpenter ? 1 : 0
  subnet_selector_name        = var.subnet_selector_name
  sg_selector_name            = var.sg_selector_name
  karpenter_ec2_capacity_type = var.karpenter_ec2_capacity_type
  karpenter_ec2_instance_type = var.karpenter_ec2_instance_type
}

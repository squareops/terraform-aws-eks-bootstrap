data "aws_region" "current" {}

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

module "service_monitor_crd" {
  count  = var.service_monitor_crd_enabled ? 1 : 0
  source = "./addons/service_monitor_crd"
}

resource "aws_iam_instance_profile" "karpenter_profile" {
  role        = var.worker_iam_role_name
  name_prefix = var.eks_cluster_name
  tags = merge(
    { "Name"        = format("%s-%s-karpenter-profile", var.environment, var.name)
      "Environment" = var.environment
    }
  )
}

module "k8s_addons" {
  depends_on     = [module.service_monitor_crd]
  source         = "./EKS-Blueprint/modules/kubernetes-addons"
  eks_cluster_id = var.eks_cluster_name

  #ebs csi driver
  enable_amazon_eks_aws_ebs_csi_driver = var.amazon_eks_aws_ebs_csi_driver_enabled
  amazon_eks_aws_ebs_csi_driver_config = {
    additional_iam_policies = [var.kms_policy_arn]
  }

  #cluster-autoscaler
  enable_cluster_autoscaler = var.cluster_autoscaler_enabled
  cluster_autoscaler_helm_config = {
    version = var.cluster_autoscaler_chart_version
    values = [templatefile("${path.module}/addons/cluster_autoscaler/cluster_autoscaler.yaml", {
      aws_region     = data.aws_region.current.name
      eks_cluster_id = var.eks_cluster_name
    })]
  }

  #metrics server
  enable_metrics_server = var.metrics_server_enabled
  metrics_server_helm_config = {
    version = var.metrics_server_helm_version
    values  = [file("${path.module}/addons/metrics_server/metrics_server.yaml")]
  }

  #keda
  enable_keda = var.keda_enabled

  #Ingress Nginx Controller
  enable_ingress_nginx = var.ingress_nginx_enabled
  ingress_nginx_helm_config = {
    version = var.ingress_nginx_version
    values = [
      templatefile("${path.module}/addons/nginx_ingress/${data.aws_eks_cluster.eks.kubernetes_network_config[0].ip_family == "ipv4" ? "nginx_ingress.yaml" : "nginx_ingress_ipv6.yaml"}", {
        enable_service_monitor = var.service_monitor_crd_enabled

      })
    ]
  }

  #Cert Manager
  enable_cert_manager                      = var.cert_manager_enabled
  cert_manager_letsencrypt_email           = var.cert_manager_letsencrypt_email
  cert_manager_install_letsencrypt_issuers = var.cert_manager_install_letsencrypt_r53_issuers
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

  enable_coredns_autoscaler = var.cluster_propotional_autoscaler_enabled
  coredns_autoscaler_helm_config = {
    values = [
      file("${path.module}/addons/cluster_propotional_autoscaler/cpa.yaml")
    ]
  }

  enable_karpenter = var.karpenter_enabled
  karpenter_helm_config = {
    values = [
      templatefile("${path.module}/addons/karpenter/karpenter.yaml", {
        eks_cluster_id            = var.eks_cluster_name,
        node_iam_instance_profile = aws_iam_instance_profile.karpenter_profile.name
        eks_cluster_endpoint      = data.aws_eks_cluster.eks.endpoint
      })
    ]
  }
  karpenter_node_iam_instance_profile = aws_iam_instance_profile.karpenter_profile.name

  enable_reloader = var.reloader_enabled
  reloader_helm_config = {
    values = [
      templatefile("${path.module}/addons/reloader/reloader.yaml", {
        enable_service_monitor = var.service_monitor_crd_enabled
      })
    ]
    namespace        = "kube-system"
    create_namespace = false
  }

  enable_aws_node_termination_handler = var.aws_node_termination_handler_enabled
  aws_node_termination_handler_helm_config = {
    version = var.node_termination_handler_version
    values = [
      templatefile("${path.module}/addons/aws_node_termination_handler/aws_nth.yaml", {
        enable_service_monitor = var.service_monitor_crd_enabled
      })
    ]
  }

  enable_amazon_eks_vpc_cni        = var.amazon_eks_vpc_cni_enabled
  enable_aws_efs_csi_driver        = var.efs_storage_class_enabled
  aws_efs_csi_driver_irsa_policies = [var.kms_policy_arn]

  # External Secrets
  enable_external_secrets = var.external_secrets_enabled

}

resource "helm_release" "cert_manager_le_http" {
  depends_on = [module.k8s_addons]
  count      = var.cert_manager_install_letsencrypt_http_issuers ? 1 : 0
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
  kms_key_id                           = var.kms_key_arn
  availability_zone                    = each.value.zone
  single_az_ebs_gp3_storage_class      = var.single_az_ebs_gp3_storage_class_enabled
  single_az_ebs_gp3_storage_class_name = each.value.name
}


### EFS
module "efs" {
  depends_on         = [module.k8s_addons]
  source             = "./addons/efs"
  name               = var.name
  count              = var.efs_storage_class_enabled ? 1 : 0
  vpc_id             = var.vpc_id
  region             = data.aws_region.current.name
  environment        = var.environment
  kms_key_id         = var.kms_key_arn
  private_subnet_ids = var.private_subnet_ids
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
  name          = var.name
  count         = var.velero_enabled ? 1 : 0
  region        = data.aws_region.current.name
  cluster_id    = var.eks_cluster_name
  environment   = var.environment
  velero_config = var.velero_config
}

module "istio" {
  depends_on                          = [helm_release.cert_manager_le_http]
  source                              = "./addons/istio"
  count                               = var.istio_enabled ? 1 : 0
  ingress_gateway_enabled             = var.istio_config.ingress_gateway_enabled
  ingress_gateway_namespace           = var.istio_config.ingress_gateway_namespace
  egress_gateway_enabled              = var.istio_config.egress_gateway_enabled
  egress_gateway_namespace            = var.istio_config.egress_gateway_namespace
  observability_enabled               = var.istio_config.observability_enabled
  envoy_access_logs_enabled           = var.istio_config.envoy_access_logs_enabled
  prometheus_monitoring_enabled       = var.istio_config.prometheus_monitoring_enabled
  cert_manager_cluster_issuer_enabled = var.istio_config.cert_manager_cluster_issuer_enabled
  cert_manager_letsencrypt_email      = var.cert_manager_letsencrypt_email
}

data "kubernetes_service" "istio-ingress" {
  depends_on = [module.istio]
  metadata {
    name      = "istio-ingressgateway"
    namespace = var.istio_config.ingress_gateway_namespace
  }
}

module "karpenter_provisioner" {
  depends_on                           = [module.k8s_addons]
  source                               = "./addons/karpenter_provisioner"
  count                                = var.karpenter_provisioner_enabled ? 1 : 0
  ipv6_enabled                         = var.ipv6_enabled
  sg_selector_name                     = var.eks_cluster_name
  subnet_selector_name                 = var.karpenter_provisioner_config.private_subnet_name
  karpenter_ec2_capacity_type          = var.karpenter_provisioner_config.instance_capacity_type
  excluded_karpenter_ec2_instance_type = var.karpenter_provisioner_config.excluded_instance_type
  instance_hypervisor                  = var.karpenter_provisioner_config.instance_hypervisor
}

resource "kubernetes_namespace" "internal_nginx" {
  count = var.internal_ingress_nginx_enabled ? 1 : 0
  metadata {
    name = "internal-ingress-nginx"
  }
}

resource "helm_release" "internal_nginx" {
  depends_on = [kubernetes_namespace.internal_nginx]
  count      = var.internal_ingress_nginx_enabled ? 1 : 0
  name       = "internal-ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.0"
  namespace  = "internal-ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  values = [
    templatefile("${path.module}/addons/internal_nginx_ingress/${data.aws_eks_cluster.eks.kubernetes_network_config[0].ip_family == "ipv4" ? "ingress.yaml" : "ingress_ipv6.yaml"}", {
      enable_service_monitor = var.service_monitor_crd_enabled
    })
  ]
}

data "kubernetes_service" "internal-nginx-ingress" {
  depends_on = [helm_release.internal_nginx]
  metadata {
    name      = "internal-ingress-nginx-controller"
    namespace = "internal-ingress-nginx"
  }
}

##KUBECLARITY
resource "kubernetes_namespace" "kube_clarity" {
  count = var.kubeclarity_enabled ? 1 : 0
  metadata {
    name = var.kubeclarity_namespace
  }
}

resource "random_password" "kube_clarity" {
  length  = 20
  special = false
}

resource "kubernetes_secret" "kube_clarity" {
  count      = var.kubeclarity_enabled ? 1 : 0
  depends_on = [kubernetes_namespace.kube_clarity]
  metadata {
    name      = "basic-auth"
    namespace = var.kubeclarity_namespace
  }

  data = {
    auth = "admin:${bcrypt(random_password.kube_clarity.result)}"
  }

  type = "Opaque"
}

resource "helm_release" "kubeclarity" {
  count      = var.kubeclarity_enabled ? 1 : 0
  name       = "kubeclarity"
  chart      = "kubeclarity"
  version    = "2.18.0"
  namespace  = var.kubeclarity_namespace
  repository = "https://openclarity.github.io/kubeclarity"
  values = [
    templatefile("${path.module}/addons/kubeclarity/values.yaml", {
      hostname  = var.kubeclarity_hostname
      namespace = var.kubeclarity_namespace
    })
  ]
}

#Kubecost

data "aws_eks_addon_version" "kubecost" {
  addon_name = "kubecost_kubecost"
  # eks_cluster_version  = var.eks_cluster_version != null ? var.eks_cluster_version :
  kubernetes_version = data.aws_eks_cluster.eks.version
  most_recent        = true
}

resource "aws_eks_addon" "kubecost" {
  count                    = var.kubecost_enabled ? 1 : 0
  cluster_name             = var.eks_cluster_name
  addon_name               = "kubecost_kubecost"
  addon_version            = data.aws_eks_addon_version.kubecost.version
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = var.worker_iam_role_arn
  preserve                 = true

}

resource "random_password" "kubecost" {
  length  = 20
  special = false
}

resource "kubernetes_secret" "kubecost" {
  count      = var.kubecost_enabled ? 1 : 0
  depends_on = [aws_eks_addon.kubecost]
  metadata {
    name      = "basic-auth"
    namespace = "kubecost"
  }

  data = {
    auth = "admin:${bcrypt(random_password.kubecost.result)}"
  }

  type = "Opaque"
}

resource "kubernetes_ingress_v1" "kubecost" {
  count                  = var.kubecost_enabled ? 1 : 0
  depends_on             = [aws_eks_addon.kubecost, module.k8s_addons, kubernetes_secret.kubecost]
  wait_for_load_balancer = true
  metadata {
    name      = "kubecost"
    namespace = "kubecost"
    annotations = {
      "kubernetes.io/ingress.class"             = "nginx"
      "cert-manager.io/cluster-issuer"          = var.cluster_issuer
      "nginx.ingress.kubernetes.io/auth-type"   = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = "basic-auth"
      "nginx.ingress.kubernetes.io/auth-realm"  = "Authentication Required - kubecost"
    }
  }
  spec {
    rule {
      host = var.kubecost_hostname
      http {
        path {
          path = "/"
          backend {
            service {
              name = "cost-analyzer-cost-analyzer"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
    tls {
      secret_name = "tls-kubecost"
      hosts       = [var.kubecost_hostname]
    }
  }
}

#hpa-coredns
resource "helm_release" "coredns-hpa" {
  name      = "corednshpa"
  namespace = "kube-system"
  chart     = "${path.module}/addons/core_dns_hpa/"
  timeout   = 600
  values = [
    templatefile("${path.module}/addons/core_dns_hpa/values.yaml", {
      minReplicas                       = var.core_dns_hpa_config.minReplicas,
      maxReplicas                       = var.core_dns_hpa_config.maxReplicas,
      corednsdeploymentname             = var.core_dns_hpa_config.corednsdeploymentname,
      targetCPUUtilizationPercentage    = var.core_dns_hpa_config.targetCPUUtilizationPercentage,
      targetMemoryUtilizationPercentage = var.core_dns_hpa_config.targetMemoryUtilizationPercentage
    })
  ]
}

resource "helm_release" "vpa-crds" {
  count      = var.metrics_server_enabled ? 1 : 0
  name       = "vertical-pod-autoscaler"
  namespace  = "kube-system"
  repository = "https://cowboysysop.github.io/charts/"
  chart      = "vertical-pod-autoscaler"
  version    = "7.2.0"
  timeout    = 600
  values = [
    file("${path.module}/addons/vpa_crds/values.yaml")
  ]
}

resource "helm_release" "metrics-server-vpa" {
  count      = var.metrics_server_enabled ? 1 : 0
  depends_on = ["helm_release.vpa-crds"]
  name       = "metricsservervpa"
  namespace  = "kube-system"
  chart      = "${path.module}/addons/metrics_server_vpa/"
  timeout    = 600
  values = [
    templatefile("${path.module}/addons/metrics_server_vpa/values.yaml", {
      minCPU                      = var.metrics_server_vpa_config.minCPU,
      minMemory                   = var.metrics_server_vpa_config.minMemory,
      maxCPU                      = var.metrics_server_vpa_config.maxCPU,
      maxMemory                   = var.metrics_server_vpa_config.maxMemory,
      metricsServerDeploymentName = var.metrics_server_vpa_config.metricsServerDeploymentName
    })
  ]
}

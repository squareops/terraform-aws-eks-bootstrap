resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  depends_on = [kubernetes_namespace.istio_system]
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  timeout    = 600
  version    = "1.18.0"
}

resource "helm_release" "istiod" {
  depends_on = [helm_release.istio_base]

  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  timeout    = 600
  version    = "1.18.0"
}

resource "kubernetes_namespace" "istio_ingress" {

  depends_on = [helm_release.istiod]
  count      = var.ingress_gateway_enabled ? 1 : 0

  metadata {
    name = var.ingress_gateway_namespace
  }

}

resource "helm_release" "istio_ingress" {
  depends_on = [helm_release.istiod, kubernetes_namespace.istio_ingress]
  count      = var.ingress_gateway_enabled ? 1 : 0
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = var.ingress_gateway_namespace
  timeout    = 600
  version    = "1.18.0"

  set {
    name  = "labels.app"
    value = "istio-ingressgateway"
  }

  set {
    name  = "labels.istio"
    value = "ingressgateway"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

}


resource "kubernetes_namespace" "istio_egress" {

  depends_on = [helm_release.istiod]
  count      = var.egress_gateway_enabled ? 1 : 0

  metadata {
    name = var.egress_gateway_namespace
  }

}
resource "helm_release" "istio_egress" {
  depends_on = [helm_release.istiod, kubernetes_namespace.istio_egress]
  count      = var.egress_gateway_enabled ? 1 : 0

  name       = "istio-egressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = var.egress_gateway_namespace
  timeout    = 600
  version    = "1.18.0"

  set {
    name  = "labels.app"
    value = "istio-egressgateway"
  }

  set {
    name  = "labels.istio"
    value = "egressgateway"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "helm_release" "istio_observability" {
  depends_on = [helm_release.istiod]
  count      = var.observability_enabled ? 1 : 0
  name       = "istio-observability"
  chart      = "${path.module}/istio-observability/"
  namespace  = "istio-system"
  set {
    name  = "accessLogging.enabled"
    value = var.envoy_access_logs_enabled
  }
  set {
    name  = "monitoring.enabled"
    value = var.prometheus_monitoring_enabled
  }
  set {
    name  = "clusterIssuer.enabled"
    value = var.cert_manager_cluster_issuer_enabled
  }
  set {
    name  = "clusterIssuer.email"
    value = var.cert_manager_letsencrypt_email
  }
}

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
  version    = "1.15.2"

}

resource "helm_release" "istiod" {
  depends_on = [helm_release.istio_base]

  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  timeout    = 600
  version    = "1.15.2"

  set {
    name  = "global.tracer.zipkin.address"
    value = "zipkin.svc.cluster:9411"
  }

  /* set {
    name  = "global.tracer.zipkin.address.co.elastic.logs/enabled"
    value = "true"
  } */
}

# resource "kubernetes_namespace" "istio_ingress" {

#   depends_on = [helm_release.istiod]

#   metadata {
#     name = "istio-ingress"

#     labels = {
#       istio-injection = "enabled"
#     }
#   }

# }

resource "helm_release" "istio_ingress" {
  depends_on = [helm_release.istiod]

  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
  timeout    = 600
  version    = "1.15.2"

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

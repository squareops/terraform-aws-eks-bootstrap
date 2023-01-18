resource "helm_release" "service-monitor-crd" {
  name    = "service-monitor-crd"
  chart   = "${path.module}/service_monitor/"
  timeout = 600
}

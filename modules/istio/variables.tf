variable "ingress_gateway_enabled" {
  description = "Enable or disable the installation of Istio Ingress Gateway."
  default     = true
  type        = bool
}

variable "ingress_gateway_namespace" {
  description = "Name of the Kubernetes namespace where the Istio Ingress Gateway will be deployed"
  default     = "istio-ingressgateway"
  type        = string
}

variable "egress_gateway_enabled" {
  description = "Enable or disable the installation of Istio Egress Gateway."
  default     = false
  type        = bool
}

variable "egress_gateway_namespace" {
  description = "Name of the Kubernetes namespace where the Istio Egress Gateway will be deployed."
  default     = "istio-egressgateway"
  type        = string
}

variable "observability_enabled" {
  description = "Enable or disable the installation of observability components"
  default     = false
  type        = bool
}

variable "envoy_access_logs_enabled" {
  description = "Enable or disable the installation of Envoy access logs across Mesh"
  default     = false
  type        = bool
}

variable "prometheus_monitoring_enabled" {
  description = "Enable or disable the installation of Prometheus Operator's servicemonitor to monitor Istio Controlplane and Dataplane"
  default     = false
  type        = bool
}

variable "cert_manager_cluster_issuer_enabled" {
  description = "Enable or disable the installation of LetsEncrypt Cluster issuer with istio Class"
  default     = false
  type        = bool
}
variable "cert_manager_letsencrypt_email" {
  description = "Specifies the email address to be used by cert-manager to request Let's Encrypt certificates"
  type        = string
}

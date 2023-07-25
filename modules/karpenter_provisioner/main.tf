resource "helm_release" "karpenter_provisioner" {
  name    = "karpenter-provisioner"
  chart   = "${path.module}/karpenter-provisioner/"
  timeout = 600
  values = var.ipv6_enabled == true ? [
    templatefile("${path.module}/karpenter-provisioner/ipv6-values.yaml", {
      subnet_selector_name                 = var.subnet_selector_name,
      sg_selector_name                     = var.sg_selector_name,
      karpenter_ec2_capacity_type          = "[${join(",", [for s in var.karpenter_ec2_capacity_type : format("%s", s)])}]",
      excluded_karpenter_ec2_instance_type = "[${join(",", var.excluded_karpenter_ec2_instance_type)}]"
      instance_hypervisor                  = "[${join(",", var.instance_hypervisor)}]"
    })
    ] : [
    templatefile("${path.module}/karpenter-provisioner/ipv4-values.yaml", {
      subnet_selector_name                 = var.subnet_selector_name,
      sg_selector_name                     = var.sg_selector_name,
      karpenter_ec2_capacity_type          = "[${join(",", [for s in var.karpenter_ec2_capacity_type : format("%s", s)])}]",
      excluded_karpenter_ec2_instance_type = "[${join(",", var.excluded_karpenter_ec2_instance_type)}]"
    })
  ]
}

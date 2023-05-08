resource "kubernetes_storage_class_v1" "single_az_sc" {
  count = var.single_az_ebs_gp3_storage_class ? 1 : 0
  metadata {
    name = var.single_az_ebs_gp3_storage_class_name
  }
  reclaim_policy         = "Retain"
  storage_provisioner    = "kubernetes.io/aws-ebs"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    type      = "gp3"
    encrypted = true
    kmskeyId  = var.kms_key_id
    zone      = var.availability_zone
  }
}

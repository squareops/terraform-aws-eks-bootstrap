data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}
module "efs" {
  source                        = "cloudposse/efs/aws"
  version                       = "0.32.7"
  kms_key_id                    = var.kms_key_id
  name                          = format("%s-%s-efs", var.environment, var.name)
  region                        = var.region
  vpc_id                        = var.vpc_id
  subnets                       = var.private_subnet_ids
  create_security_group         = false
  associated_security_group_ids = split(",", module.security_group_efs.security_group_id)
}
resource "aws_security_group_rule" "cidr_ingress" {
  description       = "From allowed CIDRs"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.existing_vpc.cidr_block]
  security_group_id = module.security_group_efs.security_group_id
}
module "security_group_efs" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
  name        = format("%s-%s-%s", var.environment, var.name, "efs-sg")
  description = "Complete PostgreSQL example security group"
  vpc_id      = var.vpc_id
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = tomap(
    {
      "Name"        = format("%s-%s-%s", var.environment, var.name, "efs-sg")
      "Environment" = var.environment
    },
  )
}

resource "kubernetes_storage_class" "efs" {
  depends_on = [module.efs]
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    provisioningMode : "efs-ap"
    fileSystemId : join("", module.efs.*.id)
    directoryPerms : "777"
  }
}

provider "archive" {}

#velero bucket lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "velero_bucket_policy" {

  bucket = var.velero_config.backup_bucket_name

  rule {
    id     = "archive"
    status = "Enabled"
    filter {
      and {
        prefix = "archive/"
        tags = {
          rule      = "archival"
          autoclean = "true"
        }
      }
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.velero_config.retention_period_in_days
    }
  }
}

resource "aws_iam_policy" "velero_iam_policy" {
  name        = format("%s-%s-velero-policy", var.name, var.environment)
  description = "Allow to get backup of cluster"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "kms:GenerateDataKey",
            "kms:CreateGrant",
            "kms:Decrypt",
            "kms:ReEncryptTo",
            "kms:ReEncryptFrom",
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:CreateSnapshot",
            "ec2:DeleteSnapshot",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObject",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts",
            "s3:ListBucket",
            "ec2:CreateSnapshot",
            "ec2:DeleteSnapshot",
            "ec2:DescribeTags",
            "ec2:ModifySnapshotAttribute",
            "ec2:GetTags",
            "iam:CreateServiceLinkedRole",
            "iam:GetRole",
            "iam:AttachRolePolicy",
            "ec2:DescribeVolumeAttribute",
            "ec2:ModifyVolumeAttribute",
            "s3:GetBucketLocation",
            "s3:CreateBucket",
            "s3:DeleteBucket",
            "s3:GetBucketPolicy",
            "s3:PutBucketPolicy",
            "s3:ListBucketMultipartUploads",
            "s3:GetObjectVersion",
            "s3:ListObjects",
            "s3:ListBucketVersions",
            "sts:AssumeRole"	,
            "autoscaling:CreateAutoScalingGroup",
            "autoscaling:DeleteAutoScalingGroup",
            "autoscaling:UpdateAutoScalingGroup",
            "ec2:DescribeInstanceTypeOfferings",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeSpotPriceHistory",
            "ec2:RequestSpotInstances",
            "ec2:TerminateInstances",
            "ec2:CreateLaunchTemplateVersion",
            "ec2:DeleteLaunchTemplateVersions",
            "ec2:CreateLaunchTemplate",
            "ec2:DeleteLaunchTemplate",
            "iam:PassRole"
        ],
        "Resource": "*"
      }
  ]
}
EOF
}

module "eks_blueprints_kubernetes_addons" {
  depends_on              = [aws_iam_policy.velero_iam_policy]
  source                  = "../../EKS-Blueprint/modules/kubernetes-addons"
  eks_cluster_id          = var.cluster_id
  enable_velero           = true
  velero_backup_s3_bucket = var.velero_config.backup_bucket_name
  velero_irsa_policies    = [aws_iam_policy.velero_iam_policy.arn]
  velero_helm_config = {
    values = [
      templatefile("${path.module}/helm/values.yaml", {
        bucket = var.velero_config.backup_bucket_name,
        region = var.region
      })
    ]
  }
}

#velero schedule job

resource "helm_release" "velero_schedule_job" {
  depends_on = [module.eks_blueprints_kubernetes_addons]
  name       = format("%s-%s-velero-schedule-job", var.name, var.environment)
  chart      = "${path.module}/velero_job/"
  timeout    = 600

  set {
    name  = "velero_backup_name"
    value = var.velero_config.velero_backup_name
  }

  set {
    name  = "schedule_cron_time"
    value = var.velero_config.schedule_backup_cron_time
  }

  set {
    name  = "namespaces"
    value = var.velero_config.namespaces == "" ? "*" : var.velero_config.namespaces
  }
}

# velero snapshot deletion policy

resource "aws_iam_role" "delete_snapshot_role" {
  depends_on         = [helm_release.velero_schedule_job]
  name               = format("%s-%s-delete-velero-snapshot", var.name, var.environment)
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "cloudwatch_policy" {
  depends_on  = [helm_release.velero_schedule_job]
  name        = format("%s-%s-cloudwatch-policy", var.name, var.environment)
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_policy" "snapshot_policy" {
  depends_on  = [helm_release.velero_schedule_job]
  name        = format("%s-%s-snapshot-policy", var.name, var.environment)
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "ec2:CreateSnapshot",
       "ec2:CreateTags",
       "ec2:DeleteSnapshot",
       "ec2:DescribeAvailabilityZones",
       "ec2:DescribeSnapshots",
       "ec2:DescribeTags",
       "ec2:DescribeVolumeAttribute",
       "ec2:DescribeVolumeStatus",
       "ec2:DescribeVolumes"
     ],
     "Resource": "*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  depends_on = [aws_iam_role.delete_snapshot_role, aws_iam_policy.cloudwatch_policy]
  role       = aws_iam_role.delete_snapshot_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_snap" {
  depends_on = [aws_iam_role.delete_snapshot_role, aws_iam_policy.snapshot_policy]
  role       = aws_iam_role.delete_snapshot_role.name
  policy_arn = aws_iam_policy.snapshot_policy.arn
}

data "template_file" "lambda_function_script" {
  template = file("${path.module}/delete-snapshot.py")
  vars = {
    retention_period_in_days = var.velero_config.retention_period_in_days,
    region                   = var.region
  }
}

resource "local_file" "rendered_template" {
  content  = data.template_file.lambda_function_script.rendered
  filename = "${path.module}/rendered/delete-snapshot.py"
}

data "archive_file" "zip" {
  depends_on  = [local_file.rendered_template]
  type        = "zip"
  output_path = "${path.module}/delete-snapshot.zip"
  source_dir  = "${path.module}/rendered/"

}

resource "aws_lambda_function" "delete_snapshot" {
  depends_on       = [aws_iam_role.delete_snapshot_role]
  function_name    = format("%s-%s-delete-velero-snapshots", var.name, var.environment)
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role             = aws_iam_role.delete_snapshot_role.arn
  handler          = "delete-snapshot.lambda_handler"
  runtime          = "python3.8"
  timeout          = 180
  memory_size      = 256
}

resource "aws_cloudwatch_event_rule" "delete_snapshot_event_rule" {
  depends_on          = [aws_lambda_function.delete_snapshot]
  name                = format("%s-%s-delete-snapshot-event-rule", var.name, var.environment)
  description         = "schevery every 4 hours."
  schedule_expression = "rate(4 hours)"
}

resource "aws_cloudwatch_event_target" "delete_snapshot_event_target" {
  depends_on = [aws_lambda_function.delete_snapshot, aws_cloudwatch_event_rule.delete_snapshot_event_rule]
  arn        = aws_lambda_function.delete_snapshot.arn
  rule       = aws_cloudwatch_event_rule.delete_snapshot_event_rule.name
}

resource "aws_lambda_permission" "cloudwatch_call_snapshot_delete_lambda" {
  depends_on    = [aws_lambda_function.delete_snapshot, aws_cloudwatch_event_rule.delete_snapshot_event_rule]
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_snapshot.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.delete_snapshot_event_rule.arn
}

resource "helm_release" "velero-notification" {
  depends_on = [helm_release.velero_schedule_job]
  name       = format("%s-%s-velero-notification", var.name, var.environment)
  repository = "https://charts.botkube.io/"
  chart      = "botkube"
  namespace  = "velero"
  version    = "0.16.0"
  values = [
    templatefile("${path.module}/velero_notification/values.yaml", {
      cluster_id         = var.cluster_id,
      slack_token        = var.velero_config.slack_notification_token,
      slack_channel_name = var.velero_config.slack_notification_channel_name
    })
  ]
}

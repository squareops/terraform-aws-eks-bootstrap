output "efs_id" {
  value       = module.efs.*.id
  description = "EFS ID"
}

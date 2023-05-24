resource "aws_ssm_parameter" "initial_admin_passoword" {
  for_each    = local.host
  name        = "/${each.value.name}/initialAdminPassword"
  description = "The initialAdminPassword for ${each.value.name}"
  type        = "String"
  value       = "initialAdminPassword"
  overwrite   = true
  tags        = merge(var.tags, local.tags)

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

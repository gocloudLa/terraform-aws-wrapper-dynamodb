module "dynamodb" {
  for_each = var.dynamodb_parameters
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version  = "5.0.0"

  create_table                          = true
  name                                  = "${local.common_name}-${each.key}"
  attributes                            = try(each.value.attributes, var.dynamodb_defaults.attributes, [])
  hash_key                              = try(each.value.hash_key, var.dynamodb_defaults.hash_key, null)
  range_key                             = try(each.value.range_key, var.dynamodb_defaults.range_key, null)
  billing_mode                          = try(each.value.billing_mode, var.dynamodb_defaults.billing_mode, "PAY_PER_REQUEST")
  write_capacity                        = try(each.value.write_capacity, var.dynamodb_defaults.write_capacity, null)
  read_capacity                         = try(each.value.read_capacity, var.dynamodb_defaults.read_capacity, null)
  point_in_time_recovery_enabled        = try(each.value.point_in_time_recovery_enabled, var.dynamodb_defaults.point_in_time_recovery_enabled, false)
  point_in_time_recovery_period_in_days = try(each.value.point_in_time_recovery_period_in_days, var.dynamodb_defaults.point_in_time_recovery_period_in_days, null)
  ttl_enabled                           = try(each.value.ttl_enabled, var.dynamodb_defaults.ttl_enabled, false)
  ttl_attribute_name                    = try(each.value.ttl_attribute_name, var.dynamodb_defaults.ttl_attribute_name, "")
  global_secondary_indexes              = try(each.value.global_secondary_indexes, var.dynamodb_defaults.global_secondary_indexes, [])
  local_secondary_indexes               = try(each.value.local_secondary_indexes, var.dynamodb_defaults.local_secondary_indexes, [])
  replica_regions                       = try(each.value.replica_regions, var.dynamodb_defaults.replica_regions, [])
  stream_enabled                        = try(each.value.stream_enabled, var.dynamodb_defaults.stream_enabled, false)
  stream_view_type                      = try(each.value.stream_view_type, var.dynamodb_defaults.stream_view_type, null)
  server_side_encryption_enabled        = try(each.value.server_side_encryption_enabled, var.dynamodb_defaults.server_side_encryption_enabled, false)
  server_side_encryption_kms_key_arn    = try(each.value.server_side_encryption_kms_key_arn, var.dynamodb_defaults.server_side_encryption_kms_key_arn, null)
  timeouts = try(each.value.timeouts, var.dynamodb_defaults.timeouts, {
    create = "10m"
    update = "60m"
    delete = "10m"
  })
  autoscaling_enabled = try(each.value.autoscaling_enabled, var.dynamodb_defaults.autoscaling_enabled, false)
  autoscaling_defaults = try(each.value.autoscaling_defaults, var.dynamodb_defaults.autoscaling_defaults, {
    scale_in_cooldown  = 0
    scale_out_cooldown = 0
    target_value       = 70
  })
  autoscaling_read            = try(each.value.autoscaling_read, var.dynamodb_defaults.autoscaling_read, {})
  autoscaling_write           = try(each.value.autoscaling_write, var.dynamodb_defaults.autoscaling_write, {})
  autoscaling_indexes         = try(each.value.autoscaling_indexes, var.dynamodb_defaults.autoscaling_indexes, {})
  table_class                 = try(each.value.table_class, var.dynamodb_defaults.table_class, null)
  deletion_protection_enabled = try(each.value.deletion_protection_enabled, var.dynamodb_defaults.deletion_protection_enabled, null)
  import_table                = try(each.value.import_table, var.dynamodb_defaults.import_table, {})
  restore_date_time           = try(each.value.restore_date_time, var.dynamodb_defaults.restore_date_time, null)
  restore_source_name         = try(each.value.restore_source_name, var.dynamodb_defaults.restore_source_name, null)
  restore_source_table_arn    = try(each.value.restore_source_table_arn, var.dynamodb_defaults.restore_source_table_arn, null)
  restore_to_latest_time      = try(each.value.restore_to_latest_time, var.dynamodb_defaults.restore_to_latest_time, null)
  resource_policy             = try(each.value.resource_policy, var.dynamodb_defaults.resource_policy, null)
  region                      = try(each.value.region, var.dynamodb_defaults.region, null)
  on_demand_throughput        = try(each.value.on_demand_throughput, var.dynamodb_defaults.on_demand_throughput, {})

  tags = local.common_tags
}
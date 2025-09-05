resource "aws_kms_key" "primary" {
  description = "CMK for primary region"
}

resource "aws_kms_key" "secondary" {
  provider    = aws.use2
  description = "CMK for secondary region"
}

module "wrapper_dynamodb" {
  source = "../../"

  metadata = local.metadata

  dynamodb_parameters = {
    "example" = {
      hash_key            = "id"
      range_key           = "title"
      billing_mode        = "PROVISIONED"
      table_class         = "STANDARD"
      read_capacity       = 5
      write_capacity      = 5
      autoscaling_enabled = true

      autoscaling_read = {
        scale_in_cooldown  = 50
        scale_out_cooldown = 40
        target_value       = 45
        max_capacity       = 10
      }

      autoscaling_write = {
        scale_in_cooldown  = 50
        scale_out_cooldown = 40
        target_value       = 45
        max_capacity       = 10
      }

      autoscaling_indexes = {
        TitleIndex = {
          read_max_capacity  = 10
          read_min_capacity  = 5
          write_max_capacity = 10
          write_min_capacity = 5
        }
      }

      autoscaling_defaults = {
        scale_in_cooldown  = 0
        scale_out_cooldown = 0
        target_value       = 70
      }

      attributes = [
        {
          name = "id"
          type = "N"
        },
        {
          name = "title"
          type = "S"
        },
        {
          name = "age"
          type = "N"
        }
      ]

      global_secondary_indexes = [
        {
          name               = "TitleIndex"
          hash_key           = "title"
          range_key          = "age"
          projection_type    = "INCLUDE"
          non_key_attributes = ["id"]
          write_capacity     = 10
          read_capacity      = 10
        }
      ]

      local_secondary_indexes = [
        {
          name               = "TitleLocalIndex"
          range_key          = "age"
          projection_type    = "INCLUDE"
          non_key_attributes = ["age", "id"]
        }
      ]

      point_in_time_recovery_enabled = false
      ttl_enabled                    = true
      ttl_attribute_name             = "ttl"

      timeouts = {
        create = "10m"
        update = "60m"
        delete = "10m"
      }

    }
    "example-2" = {
      hash_key         = "id"
      range_key        = "title"
      stream_enabled   = true
      stream_view_type = "NEW_AND_OLD_IMAGES"

      server_side_encryption_enabled     = true
      server_side_encryption_kms_key_arn = aws_kms_key.primary.arn

      attributes = [
        {
          name = "id"
          type = "N"
        },
        {
          name = "title"
          type = "S"
        },
        {
          name = "age"
          type = "N"
        }
      ]

      global_secondary_indexes = [
        {
          name               = "TitleIndex"
          hash_key           = "title"
          range_key          = "age"
          projection_type    = "INCLUDE"
          non_key_attributes = ["id"]
        }
      ]

      replica_regions = [{
        region_name    = "us-east-2"
        kms_key_arn    = aws_kms_key.secondary.arn
        propagate_tags = true
      }]
    }

    "example-resource-based-policy" = {
      hash_key         = "id"
      range_key        = "title"
      stream_enabled   = true
      stream_view_type = "NEW_AND_OLD_IMAGES"

      server_side_encryption_enabled     = true
      server_side_encryption_kms_key_arn = aws_kms_key.primary.arn

      attributes = [
        {
          name = "id"
          type = "N"
        },
        {
          name = "title"
          type = "S"
        },
        {
          name = "age"
          type = "N"
        }
      ]

      global_secondary_indexes = [
        {
          name               = "TitleIndex"
          hash_key           = "title"
          range_key          = "age"
          projection_type    = "INCLUDE"
          non_key_attributes = ["id"]

          on_demand_throughput = {
            max_write_request_units = 2
            max_read_request_units  = 2
          }
        }
      ]

      replica_regions = [{
        region_name    = "us-east-2"
        kms_key_arn    = aws_kms_key.secondary.arn
        propagate_tags = true
      }]

      resource_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Sid    = "AllowAllReadActions",
            Effect = "Allow",
            Principal = {
              AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            Action = [
              "dynamodb:GetItem",
              "dynamodb:Query",
              "dynamodb:Scan"
            ],
            Resource = "arn:aws:dynamodb:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:table/${local.common_name}-example-resource-based-policy"
          }
        ]
      })

      on_demand_throughput = {
        max_write_request_units = 2
        max_read_request_units  = 2
      }

    }

  }
  dynamodb_defaults = var.dynamodb_defaults

}
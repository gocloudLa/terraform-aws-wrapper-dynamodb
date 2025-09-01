# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform DynamoDB Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-dynamodb/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-dynamodb.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-dynamodb.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-dynamodb/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform wrapper for AWS's DynamoDB service simplifies the configuration of the NoSQL database service in the cloud. This wrapper acts as a predefined template, making it easier to create and manage tables in DynamoDB by handling all the technical details.

### ✨ Features

- 📈 [Index Autoscaling](#index-autoscaling) - It allows defining an auto-scaling policy for indexes to adapt to different use cases.

- 🌍 [Replication in another Region](#replication-in-another-region) - Enable global replication of tables in the specified regions.

- 📚 [Declaration of secondary global and local indexes](#declaration-of-secondary-global-and-local-indexes) - It allows defining secondary indexes in the table.

- 📄 [Define resource policy in the table](#define-resource-policy-in-the-table) - It allows defining specific performance.

- 📊 [Define On Demand Throughput for the table and secondary global indexes](#define-on-demand-throughput-for-the-table-and-secondary-global-indexes) - It allows defining secondary indexes in the table.



### 🔗 External Modules
| Name | Version |
|------|------:|
| [terraform-aws-modules/dynamodb-table/aws](https://github.com/terraform-aws-modules/dynamodb-table-aws) | 5.0.0 |



## 🚀 Quick Start
```hcl
dynamodb_parameters = {
  "00" = {
    ## Valores requeridos para tabla
    hash_key            = "id"
    range_key           = "title"
    billing_mode        = "PROVISIONED"
    table_class         = "STANDARD"
    read_capacity       = 10
    write_capacity      = 10

    ## Atributos para nuevas columnas
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
  }
}
dynamodb_defaults = var.dynamodb_defaults
```


## 🔧 Additional Features Usage

### Index Autoscaling
It allows defining an auto-scaling policy for indexes to adapt to different use cases.


<details><summary>Configuration Code</summary>

```hcl
dynamodb_parameters = {
  "00" = {
    ...
    ## Configuracíón de autoescalado de índices
    #autoscaling_indexes = {
    #  TitleIndex = {
    #    read_max_capacity  = 10
    #    read_min_capacity  = 5
    #    write_max_capacity = 10
    #    write_min_capacity = 5
    #  }
    #}
    ## Configuración de umbral de autoescalado
    #autoscaling_defaults = {
    #  scale_in_cooldown  = 0
    #  scale_out_cooldown = 0
    #  target_value       = 70
    #}
    ## Configuración de índices secundarios
    # global_secondary_indexes = [
    #   {
    #     name               = "TitleIndex"
    #     hash_key           = "title"
    #     range_key          = "age"
    #     projection_type    = "INCLUDE"
    #     non_key_attributes = ["id"]
    #     write_capacity     = 10
    #     read_capacity      = 10
    #   }
    # ]
  }
}
```


</details>


### Replication in another Region
Enable global replication of tables in the specified regions.


<details><summary>Configuration Code</summary>

```hcl
resource "aws_kms_key" "secondary" {
  provider = aws.use2
  description = "CMK for secondary region"
}
dynamodb_parameters = {
  "00" = {
    ...
    #replica_regions = [{
    #    region_name    = "us-east-2"
    #    kms_key_arn    = aws_kms_key.secondary.arn
    #    propagate_tags = true
    #  }
    #]
  }
}
```


</details>


### Declaration of secondary global and local indexes
It allows defining secondary indexes in the table.


<details><summary>Configuration Code</summary>

```hcl
resource "aws_kms_key" "secondary" {
  provider = aws.use2
  description = "CMK for secondary region"
}
dynamodb_parameters = {
  "00" = {
    ...
    #global_secondary_indexes = [
    #  {
    #    name               = "TitleIndex"
    #    hash_key           = "title"
    #    range_key          = "age"
    #    projection_type    = "INCLUDE"
    #    non_key_attributes = ["id"]
    #    write_capacity     = 10
    #    read_capacity      = 10
    #  }
    #]
    #local_secondary_indexes = [
    #  {
    #    name               = "TitleLocalIndex"
    #    range_key          = "age"
    #    projection_type    = "INCLUDE"
    #    non_key_attributes = ["age", "id"]
    #  }
    #]
  }
}
```


</details>


### Define resource policy in the table
It allows defining specific performance.


<details><summary>Configuration Code</summary>

```hcl
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
            Resource = "arn:aws:dynamodb:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:table/${local.common_name}-${local.project}-<object_key>"
          }
        ]
      })
```


</details>


### Define On Demand Throughput for the table and secondary global indexes
It allows defining secondary indexes in the table.


<details><summary>Configuration Code</summary>

```hcl
global_secondary_indexes = [
        {
          name               = "TitleIndex"
          hash_key           = "title"
          range_key          = "age"
          projection_type    = "INCLUDE"
          non_key_attributes = ["id"]

          # Dentro del bloque "global_secondary_indexes"
          on_demand_throughput = {
          max_write_request_units = 2
          max_read_request_units  = 2
          }
        }
      ]
# Fuera del bloque "global_secondary_indexes"
on_demand_throughput = {
        max_write_request_units = 2
        max_read_request_units  = 2
      }
```


</details>










## ⚠️ Important Notes
- **ℹ️ Declare Secondary KMS Provider:** Requires a second provider to create the KMS encryption key for the table, or reference it through a datasource.
- **ℹ️ Global vs Local Index Performance:** Understand the performance difference between global and local indexes, and use cases requiring intensive indexing.
- **ℹ️ Avoid Overly Permissive AWS Principal:** Do not use `"*"` as the AWS Principal, as it is too permissive and will be rejected by the AWS API.
- **ℹ️ Disable Resource Removal:** Disables the ability to remove a resource - set `parameter = -1` to deactivate the resource



---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la
- 🐛 **Issues**: [GitHub Issues](https://github.com/gocloudLa/issues)

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 
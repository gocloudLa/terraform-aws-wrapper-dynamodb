/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* DYNAMODB | Variable Definition                                       */
/*----------------------------------------------------------------------*/

variable "dynamodb_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "dynamodb_defaults" {
  type        = any
  description = ""
  default     = {}
}

variable "warm_throughput" {
  description = "Sets the number of warm read and write units for the specified table"
  type        = any
  default     = {}
}

variable "global_table_witness" {
  description = "Witness Region in a Multi-Region Strong Consistency deployment. Note This must be used alongside a single replica with consistency_mode set to STRONG. Other combinations will fail to provision"
  type = object({
    region_name = optional(string)
  })
  default = null
}
/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

variable "project" {
  type = string
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
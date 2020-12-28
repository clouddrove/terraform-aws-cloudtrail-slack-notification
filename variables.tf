#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Lambda Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}


variable "environment" {
  type        = string
  default     = ""
  description = "Lambda Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "enabled" {
  type        = bool
  default     = false
  description = "Whether to create lambda function."
}

variable "variables" {
  type        = map
  default     = {}
  description = "A map that defines environment variables for the Lambda function."
}

variable "bucket_arn" {
  type        = string
  default     = ""
  description = "S3 Bucket ARN."
  sensitive   = true
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "S3 Bucket Name."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

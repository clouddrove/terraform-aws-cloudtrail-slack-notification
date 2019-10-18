#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Snapshot Create Lambda Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Snapshot Create Lambda Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Snapshot Create Lambda Environment (e.g. `prod`, `dev`, `staging`)."
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
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "S3 Bucket Name."
}
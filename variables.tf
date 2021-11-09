#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Lambda Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Lambda Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Lambda Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "enabled" {
  type        = bool
  default     = false
  description = "Whether to create lambda function."
}

variable "variables" {
  type        = map(any)
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

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "tracing_mode" {
  type        = string
  default     = null
  description = "Whether to to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active."
}

variable "attach_tracing_policy" {
  type        = bool
  default     = false
  description = "Controls whether X-Ray tracing policy should be added to IAM role for Lambda Function"
}
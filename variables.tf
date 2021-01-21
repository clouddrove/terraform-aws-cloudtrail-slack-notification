#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Lambda Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://registry.terraform.io/modules/clouddrove/lambda-site-monitor/aws/"
  description = "Terraform current module repo"
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
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

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

#Module      : Cloudtrail Slack Notification
#Description : Terraform cloudtrail slack notification module variables.
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

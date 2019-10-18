# Module      : Lambda
# Description : Terraform module to create Lambda resource on AWS for managing queue.
output "log-arn" {
  value       = module.cloudtrail-logs.arn
  description = "The Amazon Resource Name (ARN) identifying your cloudtrail logs Lambda Function."
}
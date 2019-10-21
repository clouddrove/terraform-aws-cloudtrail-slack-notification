# Module      : Lambda
# Description : Terraform module to create Lambda resource on AWS for managing queue.
output "cloudtrail-slack-arn" {
  value       = module.cloudtrail-slack.arn
  description = "The Amazon Resource Name (ARN) identifying your cloudtrail logs Lambda Function."
}
#Module      : Cloudtrail Slack Notification
#Description : Terraform cloudtrail slack notification module outputs.
output "cloudtrail-slack-arn" {
  value       = module.cloudtrail-slack.arn
  description = "The Amazon Resource Name (ARN) identifying your cloudtrail logs Lambda Function."
}

output "tags" {
  value       = module.cloudtrail-slack.tags
  description = "A mapping of tags to assign to the resource."
}


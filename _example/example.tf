provider "aws" {
  region = "eu-west-1"
}

module "cloudtrail-slack-notification" {
  source = "git::https://github.com/clouddrove/terraform-aws-cloudtrail-slack-notification.git?ref=tags/0.12.0"

  name        = "cloudtrail-slack-notification"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]
  enabled     = true
  bucket_arn  = "arn:aws:s3:::security-bucket-log-clouddrove"
  bucket_name = "security-bucket-log-clouddrove"
  filename    = "./../cloudtrail_logs"
  variables = {
    "SLACK_HOOK_URL"      = "https://hooks.slack.com/services/TEE0GF0QZ/DFGHJHGFDFGHJ/YL5MzhCSJFHHUdfgh2Hs1qiMXVH",
    "SLACK_CHANNEL"       = "testing",
    "EXCLUDE_ACCOUNT_IDS" = "",
    "USER_AGENT"          = "signin.amazonaws.com"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source  = "clouddrove/s3/aws"
  version = "1.3.0"

  name        = "clouddrove-bucket"
  environment = "test"
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"
}

module "cloudtrail-slack-notification" {
  source = "./../"

  name        = "cloudtrail-slack-notification"
  environment = "test"
  label_order = ["name", "environment"]

  enabled     = true
  bucket_arn  = module.s3_bucket.arn
  bucket_name = module.s3_bucket.id
  variables = {
    slack_webhook     = "https://hooks.slack.com/services/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"
    slack_channel     = "testing"
    event_ignore_list = jsonencode(["^Describe*", "^Assume*", "^List*", "^Get*", "^Decrypt*", "^Lookup*", "^BatchGet*", "^CreateLogStream$", "^RenewRole$", "^REST.GET.OBJECT_LOCK_CONFIGURATION$", "TestEventPattern", "TestScheduleExpression", "CreateNetworkInterface", "ValidateTemplate"])
    event_alert_list  = jsonencode(["DetachRolePolicy", "ConsoleLogin"])
    user_ignore_list  = jsonencode(["^awslambda_*", "^aws-batch$", "^bamboo*", "^i-*", "^[0-9]*$", "^ecs-service-scheduler$", "^AutoScaling$", "^AWSCloudFormation$", "^CloudTrailBot$", "^SLRManagement$"])
    source_list       = jsonencode(["signin.amazonaws.com"])
  }
}

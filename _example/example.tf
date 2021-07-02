provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source  = "clouddrove/s3/aws"
  version = "0.15.0"

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
    SLACK_WEBHOOK     = "https://hooks.slack.com/services/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"
    SLACK_CHANNEL     = "testing"
    EVENT_IGNORE_LIST = jsonencode(["^Describe*", "^Assume*", "^List*", "^Get*", "^Decrypt*", "^Lookup*", "^BatchGet*", "^CreateLogStream$", "^RenewRole$", "^REST.GET.OBJECT_LOCK_CONFIGURATION$", "TestEventPattern", "TestScheduleExpression", "CreateNetworkInterface", "ValidateTemplate"])
    EVENT_ALERT_LIST  = jsonencode(["DetachRolePolicy", "ConsoleLogin"])
    USER_IGNORE_LIST  = jsonencode(["^awslambda_*", "^aws-batch$", "^bamboo*", "^i-*", "^[0-9]*$", "^ecs-service-scheduler$", "^AutoScaling$", "^AWSCloudFormation$", "^CloudTrailBot$", "^SLRManagement$"])
    SOURCE_LIST       = jsonencode(["signin.amazonaws.com"])
  }
}

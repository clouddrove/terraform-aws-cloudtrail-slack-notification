## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : Cloudtrail Logs
#Description : This terraform module is designed to create cloudtrail log.
module "cloudtrail-logs" {
  source = "git::https://github.com/clouddrove/terraform-aws-lambda.git?ref=tags/0.12.1"

  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
  enabled     = var.enabled

  filename = "./../cloudtrail_logs"
  handler  = "index.handler"
  runtime  = "python3.7"
  iam_actions = [
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:PutLogEvents",
    "s3:*"
  ]
  statement_ids = [
    "AllowExecutionFromS3Bucket"
  ]
  actions = [
    "lambda:InvokeFunction"
  ]
  principals = [
    "s3.amazonaws.com"
  ]
  source_arns = [var.bucket_arn]
  variables = var.variables
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = module.cloudtrail-logs.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
}
## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.


resource "null_resource" "main" {
  count = var.enabled ? 1 : 0
  provisioner "local-exec" {
    command = format("cd %s/slack && bash build.sh", path.module)
  }
}

#Module      : Cloudtrail Logs
#Description : This terraform module is designed to create cloudtrail log.
module "cloudtrail-slack" {
  source  = "clouddrove/lambda/aws"
  version = "0.14.0"

  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled

  filename = format("%s/slack/src", path.module)
  handler  = "index.handler"
  runtime  = "python3.7"
  iam_actions = [
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:PutLogEvents",
    "s3:*"
  ]
  timeout = 30

  names = [
    "python_layer"
  ]
  layer_filenames = [format("%s/slack/packages/Python3-slack.zip", path.module)]
  compatible_runtimes = [
    ["python3.8"]
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
  variables   = var.variables
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.enabled ? 1 : 0
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = module.cloudtrail-slack.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
}

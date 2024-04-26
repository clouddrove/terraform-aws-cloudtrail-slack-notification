## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| bucket\_arn | S3 Bucket ARN. | `string` | `""` | no |
| bucket\_name | S3 Bucket Name. | `string` | `""` | no |
| enabled | Whether to create lambda function. | `bool` | `false` | no |
| environment | Lambda Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| filter\_prefix | Specifies object key name prefix. | `string` | `""` | no |
| filter\_suffix | Specifies object key name suffix. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Lambda Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-cloudtrail-slack-notification"` | no |
| variables | A map that defines environment variables for the Lambda function. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudtrail-slack-arn | The Amazon Resource Name (ARN) identifying your cloudtrail logs Lambda Function. |
| tags | A mapping of tags to assign to the resource. |


# AWS account info
data "aws_caller_identity" "current" {}

# IAM policy for ESO
data "aws_iam_policy_document" "eso_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:prod/db/*"
    ]
  }
}
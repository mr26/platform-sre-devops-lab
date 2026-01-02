# IAM policy for Secrets Manager access
data "aws_iam_policy_document" "eso_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["*"]
  }
}

# IAM role for ServiceAccount (IRSA)
resource "aws_iam_role" "eso_irsa_role" {
  name = "eso-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

# Attach policy
resource "aws_iam_role_policy" "eso_policy_attachment" {
  name   = "eso-secretsmanager-policy"
  role   = aws_iam_role.eso_irsa_role.id
  policy = data.aws_iam_policy_document.eso_policy.json
}
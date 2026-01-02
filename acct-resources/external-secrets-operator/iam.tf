# IAM Role for IRSA
resource "aws_iam_role" "eso_irsa_role" {
  name = "eso-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.eks_oidc_provider
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(var.eks_oidc_provider, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
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

############################
# EKS + OIDC data sources
############################

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_caller_identity" "current" {}

############################
# IAM Role for IRSA
############################

resource "aws_iam_role" "app_irsa" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.this.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

############################
# IAM Policy
############################

resource "aws_iam_policy" "app_policy" {
  name        = "${var.iam_role_name}-policy"
  description = "Permissions for auth-gateway and notes API"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      ############################
      # Secrets Manager
      ############################
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      },

      ############################
      # Cognito
      ############################
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:InitiateAuth",
          "cognito-idp:RespondToAuthChallenge"
        ]
        Resource = "*"
      },

      ############################
      # RDS - describe
      ############################
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters"
        ]
        Resource = "*"
      },

      ############################
      # RDS - IAM authentication
      ############################
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = "arn:aws:rds-db:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.db_resource_id}/${var.db_username}"
      },

      ############################
      # S3 (wildcard for now)
      ############################
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }

    ]
  })
}

############################
# Attach policy to role
############################

resource "aws_iam_role_policy_attachment" "app_policy_attach" {
  role       = aws_iam_role.app_irsa.name
  policy_arn = aws_iam_policy.app_policy.arn
}

############################
# Outputs
############################

output "app_irsa_role_arn" {
  value = aws_iam_role.app_irsa.arn
}

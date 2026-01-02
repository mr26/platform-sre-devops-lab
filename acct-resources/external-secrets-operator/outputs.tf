output "eso_iam_role_arn" {
  description = "ARN of the IAM role for ESO IRSA"
  value       = aws_iam_role.eso_irsa_role.arn
}

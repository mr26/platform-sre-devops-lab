output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "secrets_manager_secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}

output "db_resource_id" {
  value       = aws_db_instance.this.resource_id
  description = "Resource ID for IAM DB authentication"
}
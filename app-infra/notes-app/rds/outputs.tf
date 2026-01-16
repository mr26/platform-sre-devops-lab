output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "secrets_manager_secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}

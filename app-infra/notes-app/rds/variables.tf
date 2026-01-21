# AWS region
variable "aws_region" {
  description = "AWS region"
  type        = string
}

# Existing VPC ID
variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

# Private subnets for RDS
variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

# Allowed CIDR blocks that can access the DB (e.g., EKS cluster CIDR)
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the RDS instance"
  type        = list(string)
  default     = []
}

# Database name
variable "db_name" {
  description = "Database name"
  type        = string
}

# Initial database to create inside RDS
variable "initial_db_name" {
  description = "Initial database name inside the RDS instance"
  type        = string
}

# Master username
variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

# Engine type
variable "engine" {
  description = "RDS engine type"
  type        = string
  default     = "mysql"
}

# Engine version
variable "engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0"
}

# RDS instance class
variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

# Allocated storage in GB
variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

# Multi-AZ deployment
variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}

# DB port
variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}
output "db_resource_id" {
  value = aws_db_instance.this.resource_id
  description = "Resource ID used for IAM DB authentication"
}
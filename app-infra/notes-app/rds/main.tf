############################
# Random password for DB
############################
resource "random_password" "db" {
  length  = 20
  special = true
}

############################
# AWS Secrets Manager secret
############################
resource "aws_secretsmanager_secret" "db" {
  name = "${var.db_name}-credentials"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
  })
}

############################
# Get VPC
############################
data "aws_vpc" "selected" {
  id = var.vpc_id
}

############################
# DB subnet group
############################
resource "aws_db_subnet_group" "db" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

############################
# Security group for RDS
############################
resource "aws_security_group" "rds" {
  name        = "${var.db_name}-rds-sg"
  description = "RDS access for ${var.db_name}"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    cidr_blocks     = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-rds-sg"
  }
}

############################
# RDS instance
############################
resource "aws_db_instance" "this" {
  identifier             = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  username               = var.db_username
  password               = random_password.db.result
  db_name                = var.initial_db_name

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  multi_az            = var.multi_az
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = var.db_name
  }
}

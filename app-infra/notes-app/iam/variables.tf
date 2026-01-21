############################
# EKS cluster info
############################

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace where the ServiceAccount exists"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name for IRSA"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name for IRSA"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

############################
# RDS
############################

variable "db_username" {
  description = "Database username for IAM DB authentication"
  type        = string
}

variable "db_resource_id" {
  description = "Resource ID for IAM DB authentication"
  type        = string
}
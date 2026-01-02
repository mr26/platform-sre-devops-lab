variable "cluster_name" {
  description = "EKS cluster name"
  default     = "mgmt-cluster"
}

variable "namespace" {
  description = "Kubernetes namespace of the service account"
  default     = "external-secrets"
}

variable "service_account_name" {
  description = "Kubernetes service account name"
  default     = "external-secrets-sa"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
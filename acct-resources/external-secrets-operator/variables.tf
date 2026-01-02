variable "eks_oidc_provider" {
  description = "OIDC provider URL for the EKS cluster"
  default     = "https://oidc.eks.us-east-1.amazonaws.com/id/FC0D637E14CD3D170D44594D455232EA"
}

variable "namespace" {
  description = "Namespace where ESO ServiceAccount will live"
  default     = "external-secrets"
}

variable "service_account_name" {
  description = "ServiceAccount that ESO pods will use"
  default     = "external-secrets-sa"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
# Get AWS account ID dynamically
data "aws_caller_identity" "current" {}

# Get cluster info
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}
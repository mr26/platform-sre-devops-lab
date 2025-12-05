module "bootstrap" {
  source = "../../eks-atlantis-bootstrap"
  # pass any required variables
  my_public_ip = var.my_public_ip
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"


  name    = var.cluster_name
  subnet_ids      = module.bootstrap.subnet_ids
  vpc_id          = module.bootstrap.vpc_id
  enable_cluster_creator_admin_permissions = true
  endpoint_public_access = true
  endpoint_public_access_cidrs = [var.my_public_ip]



  eks_managed_node_groups = {
    bootstrap_nodes = {
      desired_capacity = var.desired_capacity
      max_capacity     = 1
      min_capacity     = 1
      instance_type    = var.node_instance_type
      additional_tags  = { Name = "bootstrap-eks-node" }
      node_role_arn    = aws_iam_role.eks_node_group_role.arn
    }
  }
}
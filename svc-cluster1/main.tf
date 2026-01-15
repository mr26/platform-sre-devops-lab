data "aws_caller_identity" "current" {}

##################################
# EKS Cluster
################################## 

resource "aws_eks_cluster" "svc_cluster1" {
  name = "svc-cluster1"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn
  version   = "1.33"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = [var.my_public_ip]
  }
}

##################################
# Node Group
##################################

resource "aws_eks_node_group" "svc_cluster1_nodes" {
  cluster_name    = aws_eks_cluster.svc_cluster1.name
  node_group_name = "svc_cluster1_nodes"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnet_ids

  ami_type        = "AL2_ARM_64"
  instance_types  = ["t4g.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.svc_cluster1
  ]
}

##################################
# EKS Addons (now wait for nodes)
##################################

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.svc_cluster1.name
  addon_name   = "vpc-cni"

  depends_on = [
    aws_eks_node_group.svc_cluster1_nodes
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.svc_cluster1.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_node_group.svc_cluster1_nodes
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.svc_cluster1.name
  addon_name   = "kube-proxy"

  depends_on = [
    aws_eks_node_group.svc_cluster1_nodes
  ]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.svc_cluster1.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_node_group.svc_cluster1_nodes
  ]
}

##################################
# Access Entries (EKS API Auth)
##################################

resource "aws_eks_access_entry" "admin_access_entry1" {
  cluster_name  = aws_eks_cluster.svc_cluster1.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/infra_user"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_policy1" {
  cluster_name  = aws_eks_cluster.svc_cluster1.name
  principal_arn = aws_eks_access_entry.admin_access_entry1.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

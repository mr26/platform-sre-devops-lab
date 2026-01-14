resource "aws_security_group_rule" "allow_internal_all_ports_to_control_plane" {
  type              = "ingress"
  protocol          = "-1"     # all protocols
  from_port         = 0
  to_port           = 0

  security_group_id = aws_eks_cluster.svc_cluster1.vpc_config[0].cluster_security_group_id
  cidr_blocks       = ["10.0.0.0/8"]

  description = "Allow all traffic from internal VPC to EKS control plane"
}
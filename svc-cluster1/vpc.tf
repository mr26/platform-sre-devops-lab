resource "aws_security_group" "eks_cluster_sg" {
  name        = "svc-cluster1-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  # Allow all traffic from 10.0.0.0/8
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"         # -1 means all protocols
    cidr_blocks = ["10.0.0.0/8"]
    description = "Allow all traffic from private VPC range"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "svc-cluster1-sg"
  }
}

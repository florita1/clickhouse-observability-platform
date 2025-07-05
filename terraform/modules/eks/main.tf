resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.public_subnet_ids
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "default"
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.small"]
  capacity_type  = "SPOT"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_fargate_profile" "observability" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "observability"
  pod_execution_role_arn = var.fargate_pod_execution_role_arn
  subnet_ids             = var.public_subnet_ids

  selector {
    namespace = "observability"
  }

  depends_on = [aws_eks_cluster.this]
}

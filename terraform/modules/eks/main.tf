resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.public_subnet_ids
    endpoint_public_access = true
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

  instance_types = ["t3.medium"]  # Use an on-demand instance
  capacity_type  = "ON_DEMAND"

  depends_on = [aws_eks_cluster.this]
}

# resource "aws_eks_fargate_profile" "observability" {
#   cluster_name           = aws_eks_cluster.this.name
#   fargate_profile_name   = "observability"
#   pod_execution_role_arn = var.fargate_pod_execution_role_arn
#   subnet_ids             = var.public_subnet_ids
#
#   selector {
#     namespace = "observability"
#   }
#
#   depends_on = [aws_eks_cluster.this]
# }

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
  addon_version = "v1.16.2-eksbuild.1" # Optional: pin a known stable version
  configuration_conflict_resolution = "OVERWRITE"

  configuration_values = jsonencode({
    env = [
      {
        name  = "ENABLE_PREFIX_DELEGATION"
        value = "true"
      },
      {
        name  = "WARM_PREFIX_TARGET"
        value = "1"
      }
    ]
  })

  depends_on = [aws_eks_cluster.this]
}


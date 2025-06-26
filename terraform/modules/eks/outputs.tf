output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "fargate_profile_name" {
  value = aws_eks_fargate_profile.observability.fargate_profile_name
}
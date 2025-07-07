output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "API server endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

# output "fargate_profile_name" {
#   description = "Name of the Fargate profile used for observability"
#   value       = aws_eks_fargate_profile.observability.fargate_profile_name
# }

output "cluster_ca_certificate" {
  description = "Base64-encoded EKS cluster CA data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

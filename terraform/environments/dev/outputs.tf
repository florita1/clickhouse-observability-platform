output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "fargate_profile_name" {
  value = module.eks.fargate_profile_name
}

output "argocd_server_url" {
  value = module.argocd.argocd_server_url
}

output "argocd_admin_password_cmd" {
  value = module.argocd.argocd_admin_password_cmd
}

output "clickhouse_user" {
  value = module.clickhouse.clickhouse_user
}

output "clickhouse_database" {
  value = module.clickhouse.clickhouse_database
}

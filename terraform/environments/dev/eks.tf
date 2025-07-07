module "eks" {
  source = "../../modules/eks"

  cluster_name                   = "clickhouse-observability-cluster"
  cluster_role_arn               = module.iam.eks_cluster_role_arn
  node_group_role_arn            = module.iam.eks_node_group_role_arn
  # fargate_pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  public_subnet_ids              = module.vpc.public_subnet_ids
}

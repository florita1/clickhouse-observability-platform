module "eks" {
  source = "../../modules/eks"

  cluster_name                   = "clickhouse-observability-cluster"
  cluster_role_arn               = aws_iam_role.eks_cluster_role.arn
  node_group_role_arn            = aws_iam_role.eks_node_group_role.arn
  fargate_pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn


  private_subnet_ids = module.vpc.private_subnet_ids
}
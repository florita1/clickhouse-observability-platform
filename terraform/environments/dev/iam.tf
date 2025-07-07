module "iam" {
  source = "../../modules/iam"

  cluster_role_name     = "eks-cluster-role"
  node_group_role_name  = "eks-nodegroup-role"
}

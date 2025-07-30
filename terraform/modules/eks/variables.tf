variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "node_group_role_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
  description = "List of public subnet IDs to be used for EKS cluster, nodes, and Fargate profiles"
}

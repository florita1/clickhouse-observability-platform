variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "node_group_role_arn" {
  type = string
}

variable "fargate_pod_execution_role_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}
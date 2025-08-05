provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig.yaml"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_version = ">= 1.11.0"

  required_providers {
    clickhousedbops = {
      version = "1.1.0"
      source  = "ClickHouse/clickhousedbops"
    }
  }
}

provider "clickhousedbops" {
  host     = "localhost"
  port     = 8123
  protocol = "http"

  auth_config = {
    strategy = "basicauth"
    username = var.clickhouse_admin_user
    password = var.clickhouse_admin_password
  }

}

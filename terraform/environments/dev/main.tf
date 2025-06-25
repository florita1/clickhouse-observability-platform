provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  az_count = var.az_count
  tags     = var.tags
}

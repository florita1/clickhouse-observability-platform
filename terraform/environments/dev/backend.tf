terraform {
  backend "s3" {
    bucket         = "clickhouse-observability-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

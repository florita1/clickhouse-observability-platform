variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_count" {
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {
    Environment = "dev"
  }
}


variable "clickhouse_password" {
  type      = string
  sensitive = true
}

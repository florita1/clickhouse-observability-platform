variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_count" {
  default = 2
}

variable "tags" {
  default = {
    Project = "clickhouse-observability"
    Env     = "dev"
  }
}

variable "clickhouse_user" {
  description = "ClickHouse username used for authentication"
  type        = string
  default     = "default"
}

variable "clickhouse_password" {
  description = "ClickHouse password used for authentication"
  type        = string
  sensitive   = true
}

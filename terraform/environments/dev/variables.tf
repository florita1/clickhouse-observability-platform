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

variable "clickhouse_host" {
  description = "Public or internal hostname of ClickHouse"
  type        = string
  default     = "clickhouse.clickhouse.svc.cluster.local"
}

variable "clickhouse_admin_user" {
  type    = string
  default = "default"
}

variable "clickhouse_admin_password" {
  type = string
}

variable "clickhouse_ingestor_user" {
  type = string
  default = "ingestor"
}

variable "clickhouse_ingestor_password" {
  type = string
}

variable "clickhouse_lb_host" {
  description = "Public hostname of the ClickHouse LoadBalancer service"
  type        = string
}

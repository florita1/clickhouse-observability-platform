variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "user_name" {
  description = "Name of the ClickHouse user to create"
  type        = string
}

variable "user_password" {
  description = "Password for the ClickHouse user"
  type        = string
}

variable "role_name" {
  description = "Role to assign to the user"
  type        = string
}

variable "table_name" {
  description = "Target table for privilege grants"
  type        = string
}

variable "clickhouse_host" {
  description = "ClickHouse host (DNS or IP)"
  type        = string
}

variable "admin_user" {
  description = "Admin username for ClickHouse"
  type        = string
  default     = "terraform"
}

variable "admin_password" {
  description = "Admin password for ClickHouse"
  type        = string
}

variable "enable_postdeploy" {
  type = bool
}
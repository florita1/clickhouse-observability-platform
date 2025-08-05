terraform {
  required_providers {
    clickhousedbops = {
      source  = "ClickHouse/clickhousedbops"
      version = "1.1.0"
    }
  }
}

resource "clickhousedbops_user" "user" {
  count = var.enable_postdeploy ? 1 : 0

  name                            = var.user_name
  password_sha256_hash_wo         = sha256(var.user_password)
  password_sha256_hash_wo_version = 1
}

resource "clickhousedbops_role" "role" {
  count = var.enable_postdeploy ? 1 : 0

  name = var.role_name
}

resource "clickhousedbops_grant_privilege" "insert" {
  count = var.enable_postdeploy ? 1 : 0

  privilege_name    = "INSERT"
  database_name     = var.database_name
  table_name        = var.table_name
  grantee_role_name = length(clickhousedbops_role.role) > 0 ? clickhousedbops_role.role[0].name : ""
}

resource "clickhousedbops_grant_role" "user_bind" {
  count = var.enable_postdeploy ? 1 : 0

  role_name         = length(clickhousedbops_role.role) > 0 ? clickhousedbops_role.role[0].name : ""
  grantee_user_name = length(clickhousedbops_user.user) > 0 ? clickhousedbops_user.user[0].name : ""
}

resource "kubernetes_secret" "clickhouse_ingestor" {
  count = var.enable_postdeploy ? 1 : 0

  metadata {
    name      = "clickhouse-secret"
    namespace = "ingestion"
  }

  data = {
    password = var.user_password
  }

  type = "Opaque"
}

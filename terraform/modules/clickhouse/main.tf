terraform {
  required_providers {
    clickhousedbops = {
      source  = "ClickHouse/clickhousedbops"
      version = "1.1.0"
    }
  }
}

resource "null_resource" "wait_for_clickhouse" {
  provisioner "local-exec" {
    command = <<-EOT
      for i in {1..60}; do
        nc -zv clickhouse.clickhouse.svc.cluster.local 8123 && exit 0
        echo "Waiting for ClickHouse to be available..."
        sleep 5
      done
      echo "ClickHouse not reachable after timeout" >&2
      exit 1
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "clickhousedbops_database" "db" {
  name = var.database_name

  depends_on = [null_resource.wait_for_clickhouse]

}

resource "clickhousedbops_user" "user" {
  name                         = var.user_name
  password_sha256_hash_wo     = sha256(var.user_password)
  password_sha256_hash_wo_version = 1

  depends_on = [null_resource.wait_for_clickhouse]

}

resource "clickhousedbops_role" "role" {
  name = var.role_name

  depends_on = [null_resource.wait_for_clickhouse]

}

resource "clickhousedbops_grant_privilege" "insert" {
  privilege_name    = "INSERT"
  database_name     = var.database_name
  table_name        = var.table_name
  grantee_role_name = clickhousedbops_role.role.name

  depends_on = [null_resource.wait_for_clickhouse]

}

resource "clickhousedbops_grant_role" "user_bind" {
  role_name         = clickhousedbops_role.role.name
  grantee_user_name = clickhousedbops_user.user.name

  depends_on = [null_resource.wait_for_clickhouse]

}

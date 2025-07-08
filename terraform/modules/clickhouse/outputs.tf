output "clickhouse_database" {
  value = clickhousedbops_database.db.name
}

output "clickhouse_user" {
  value = clickhousedbops_user.user.name
}

output "clickhouse_role" {
  value = clickhousedbops_role.role.name
}

output "wait_for_clickhouse" {
  value = null_resource.wait_for_clickhouse
}

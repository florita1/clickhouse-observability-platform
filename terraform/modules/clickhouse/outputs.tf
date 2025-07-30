output "clickhouse_user" {
  value = length(clickhousedbops_user.user) > 0 ? clickhousedbops_user.user[0].name : ""
}

output "clickhouse_role" {
  value = length(clickhousedbops_role.role) > 0 ? clickhousedbops_role.role[0].name : ""
}

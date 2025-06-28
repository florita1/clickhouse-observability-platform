resource "kubernetes_manifest" "clickhouse_app" {
  manifest = yamldecode(file("${path.module}/../../apps/clickhouse.yaml"))
}
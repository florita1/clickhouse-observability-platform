resource "kubernetes_manifest" "clickhouse_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/clickhouse.yaml"))
}

resource "kubernetes_manifest" "ingestion_service_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/ingestion-service.yaml"))
}

resource "kubernetes_secret" "clickhouse" {
  metadata {
    name      = "clickhouse-secret"
    namespace = "ingestion"
  }

  data = {
    password = var.clickhouse_password
  }

  type = "Opaque"
}

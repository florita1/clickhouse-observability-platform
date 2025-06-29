resource "kubernetes_manifest" "clickhouse_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/clickhouse.yaml"))
}

resource "kubernetes_manifest" "ingestion_service_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/ingestion-service.yaml"))
}

resource "kubernetes_secret" "ghcr_creds" {
  metadata {
    name      = "ghcr-creds"
    namespace = "ingestion"
  }

  data = {
    ".dockerconfigjson" = "ewoJImF1dGhzIjogewoJCSJnaGNyLmlvIjoge30KCX0sCgkiY3JlZHNTdG9yZSI6ICJkZXNrdG9wIiwKCSJjdXJyZW50Q29udGV4dCI6ICJkZXNrdG9wLWxpbnV4Igp9%"
  }

  type = "kubernetes.io/dockerconfigjson"
}
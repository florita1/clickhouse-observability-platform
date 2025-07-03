resource "kubernetes_namespace" "clickhouse" {
  metadata {
    name = "clickhouse"
  }
}

resource "helm_release" "clickhouse" {
  name       = "clickhouse"
  namespace  = kubernetes_namespace.clickhouse.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "clickhouse"
  version    = "5.1.2"

  values = [
    file("${path.module}/../../helm/clickhouse/values.yaml")
  ]

  depends_on = [kubernetes_namespace.clickhouse]
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

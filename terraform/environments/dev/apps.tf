resource "kubernetes_manifest" "clickhouse_app" {
  provider = kubernetes-alpha
  manifest = yamldecode(file("${path.module}/../../../apps/clickhouse.yaml"))
  depends_on = [module.eks]
}

resource "kubernetes_manifest" "ingestion_service_app" {
  provider = kubernetes-alpha
  manifest = yamldecode(file("${path.module}/../../../apps/ingestion-service.yaml"))
  depends_on = [module.eks]
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

  depends_on = [module.eks]
}
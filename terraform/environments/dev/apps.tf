resource "kubernetes_manifest" "ingestion_service_app" {
  count = var.enable_postdeploy ? 1 : 0

  manifest = yamldecode(file("${path.module}/../../../apps/ingestion-service.yaml"))
  depends_on = [module.eks]
}

resource "kubernetes_manifest" "clickhouse_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/clickhouse-crd.yaml"))
  depends_on = [module.eks]
}
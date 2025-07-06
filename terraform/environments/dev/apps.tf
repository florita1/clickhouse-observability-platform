resource "kubernetes_manifest" "ingestion_service_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/ingestion-service.yaml"))
  depends_on = [module.eks]
}
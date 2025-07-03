resource "kubernetes_manifest" "clickhouse_app" {
  manifest = yamldecode(file("${path.module}/../../../apps/clickhouse.yaml"))
}

resource "null_resource" "clickhouse_init" {
  depends_on = [kubernetes_manifest.clickhouse_app]

  provisioner "local-exec" {
    command = <<EOT
      kubectl run clickhouse-init-job --rm -i --tty --restart=Never \
        --image=curlimages/curl -n clickhouse -- \
        sh -c "echo '${file("${path.module}/../../../scripts/init_clickhouse.sql")}' | \
          curl -sS -u ${var.clickhouse_user}:${var.clickhouse_password} \
          -X POST http://clickhouse.clickhouse.svc.cluster.local:8123 --data-binary @-"
    EOT

    environment = {
      CLICKHOUSE_USER     = var.clickhouse_user
      CLICKHOUSE_PASSWORD = var.clickhouse_password
    }
  }

  triggers = {
    always_run = timestamp()
  }
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

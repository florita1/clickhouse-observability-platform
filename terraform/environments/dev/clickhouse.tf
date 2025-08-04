module "clickhouse" {
  source = "../../modules/clickhouse"

  clickhouse_host = var.clickhouse_host
  admin_user      = var.clickhouse_admin_user
  admin_password  = var.clickhouse_admin_password

  user_name     = var.clickhouse_ingestor_user
  user_password = var.clickhouse_ingestor_password

  database_name = "events_db"

  role_name = "ingest_only"

  table_name = "events"

  enable_postdeploy = var.enable_postdeploy
}

resource "kubernetes_secret" "clickhouse_ingestor" {
  metadata {
    name      = "clickhouse-secret"
    namespace = "ingestion"
  }

  data = {
    password = var.clickhouse_ingestor_password
  }

  type = "Opaque"
}


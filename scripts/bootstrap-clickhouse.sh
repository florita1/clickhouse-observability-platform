#!/bin/bash
set -euo pipefail

NAMESPACE="clickhouse"
LABEL="clickhouse.altinity.com/chi=clickhouse"
DDL_FILE="ddl/init.sql"

echo "Waiting for ClickHouse pod to enter 'Running' state..."
until kubectl get pods -n "$NAMESPACE" -l "$LABEL" -o jsonpath="{.items[0].status.phase}" 2>/dev/null | grep -q "Running"; do
  sleep 5
done

POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "$LABEL" -o jsonpath="{.items[0].metadata.name}")

echo "ClickHouse pod $POD_NAME is running."
echo "Applying DDL from $DDL_FILE..."
kubectl exec -n "$NAMESPACE" -it "$POD_NAME" -- clickhouse-client --multiquery < "$DDL_FILE" || {
  echo "DDL execution failed"
  exit 1
}

echo "DDL applied. Ready for post-deploy Terraform provisioning."

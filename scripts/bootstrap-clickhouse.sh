#!/bin/bash

set -euo pipefail

echo "Manually installing Prometheus CRDs"
kubectl apply -f prometheus-crds/
echo "Waiting for CRDs to be ready..."
kubectl wait --for=condition=Established crd/servicemonitors.monitoring.coreos.com --timeout=60s
kubectl apply -f apps/prometheus.yaml

NAMESPACE="clickhouse"
LABEL="clickhouse.altinity.com/chi=clickhouse"
DDL_FILE="ddl/init.sql"

echo "Waiting for ClickHouse pod to enter phase 'Running'..."

while true; do
  POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "$LABEL" -o jsonpath="{.items[0].metadata.name}" 2>/dev/null || true)
  if [[ -n "$POD_NAME" ]]; then
    phase=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}' || echo "Unknown")
    echo "Pod: $POD_NAME, Phase: $phase"
    if [[ "$phase" == "Running" ]]; then
      break
    fi
  fi
  sleep 5
done

echo "Pod $POD_NAME is running. Executing DDL from $DDL_FILE..."

kubectl exec -n "$NAMESPACE" -it "$POD_NAME" -- clickhouse-client --multiquery < "$DDL_FILE" || {
  echo "DDL execution failed"
  exit 1
}

echo "DDL applied. Port-forwarding ClickHouse on localhost:8123..."

# Port-forward in background and capture PID
kubectl port-forward -n "$NAMESPACE" pod/"$POD_NAME" 8123:8123 &
PORT_FWD_PID=$!

# Wait a moment to ensure it's listening
sleep 3

echo "Running Terraform to provision users and ingestion..."

cd terraform/environments/dev/
terraform apply -var="enable_postdeploy=true"

# Clean up port-forward process
echo "Cleaning up port-forward..."
kill "$PORT_FWD_PID"

echo "Restarting ingestion-service to connect to ClickHouse..."
kubectl rollout restart deployment ingestion-service -n ingestion
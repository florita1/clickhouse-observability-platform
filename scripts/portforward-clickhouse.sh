#!/bin/bash
set -euo pipefail

NAMESPACE="clickhouse"
LABEL="clickhouse.altinity.com/chi=clickhouse"
PORT=8123

echo "Locating ClickHouse pod..."
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "$LABEL" -o jsonpath="{.items[0].metadata.name}")

echo "Starting port-forward on pod: $POD_NAME"
kubectl port-forward -n "$NAMESPACE" pod/"$POD_NAME" $PORT:$PORT &
PORT_FWD_PID=$!
echo $PORT_FWD_PID > port_forward.pid

echo "Waiting for ClickHouse to be reachable on localhost:$PORT..."
for i in {1..10}; do
  if curl -sf "http://localhost:$PORT" > /dev/null; then
    echo "ClickHouse is reachable!"
    exit 0
  fi
  sleep 3
done

echo "ERROR: ClickHouse not reachable on localhost:$PORT after retries"
kill "$PORT_FWD_PID" || true
exit 1

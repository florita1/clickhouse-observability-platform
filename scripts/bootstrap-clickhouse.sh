#!/bin/bash

set -euo pipefail

echo "Waiting for ClickHouse pod to be Ready..."
kubectl wait pod -n clickhouse -l app=clickhouse --for=condition=Ready --timeout=180s

echo "ClickHouse is Ready. Running DDL..."
POD=$(kubectl get pod -n clickhouse -l app=clickhouse -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n clickhouse -it "$POD" -- clickhouse-client --multiquery < ddl/init.sql

echo "Running Terraform to provision users and ingestion..."
cd terraform/environments/dev/
terraform apply -var="enable_postdeploy=true"

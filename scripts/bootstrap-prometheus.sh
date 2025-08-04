#!/bin/bash
set -euo pipefail

echo "Installing Prometheus CRDs..."
kubectl apply -f prometheus-crds/

echo "Waiting for ServiceMonitor CRD to be ready..."
kubectl wait --for=condition=Established crd/servicemonitors.monitoring.coreos.com --timeout=60s

echo "Deploying Prometheus via Argo CD app..."
kubectl apply -f apps/prometheus.yaml
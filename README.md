# 🧠 ClickHouse Observability Platform (Terraform Phase)

This repository contains Terraform code for provisioning a production-ready AWS EKS environment to support a real-time observability platform built on ClickHouse, Grafana, Tempo, Loki, and Alloy. It serves as the infrastructure foundation for a GitOps-managed data and telemetry stack.

---

## CI Status

| Workflow | Status                                                                                                                 |
|----------|------------------------------------------------------------------------------------------------------------------------|
| Terraform | ![Terraform](https://github.com/florita1/clickhouse-observability-platform/actions/workflows/terraform.yaml/badge.svg) |
| Helm Charts | ![Helm](https://github.com/florita1/clickhouse-observability-platform/actions/workflows/helm.yaml/badge.svg)           |
| Argo CD | ![Argo CD](https://github.com/florita1/clickhouse-observability-platform/actions/workflows/argocd.yaml/badge.svg)      |

## 📁 Repo Structure

```
.
clickhouse-observability-platform/
├── README.md
├── apps/                            # Argo CD Application manifests
│   └── clickhouse.yaml              # GitOps app for ClickHouse via Helm
├── helm/                            # Helm charts for internal components
│   └── clickhouse/                  # Minimal ClickHouse Helm chart
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           └── service.yaml
└── terraform/                       # Full infrastructure-as-code
    ├── environments/
    │   └── dev/                     # Environment-specific config
    │       ├── apps.tf             # Argo CD Application resource via TF
    │       ├── argocd.tf           # Argo CD Helm release
    │       ├── eks.tf              # EKS cluster and node group wiring
    │       ├── iam.tf              # IAM roles and IRSA setup
    │       ├── outputs.tf          # Cluster and app outputs
    │       ├── providers.tf        # AWS, K8s, Helm provider setup
    │       ├── variables.tf
    │       └── vpc.tf              # VPC module wiring
    └── modules/                    # Reusable Terraform modules
        ├── argocd/
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── values.yaml
        ├── eks/
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        └── vpc/
            ├── main.tf
            ├── outputs.tf
            └── variables.tf

```

---

## 🚀 Infrastructure Provisioning

This portion of the project provisions:

This Terraform stack provisions:

- A highly-available VPC:
  - Public and private subnets across AZs 
  - Route tables, IGW, and NAT Gateways
- An Amazon EKS cluster with:
  - Managed node groups and optional Fargate profiles 
  - IAM roles scoped for Kubernetes workloads
- A GitOps control plane using Argo CD, installed via Helm and Terraform 
  - Exposed locally via port-forwarding 
  - Configured in HTTP mode for development convenience
- Deploys ClickHouse via Argo CD as a Helm chart, with full GitOps lifecycle management
---

## 🛠️ Usage Instructions

```bash
cd terraform/environments/dev

# 1. Format, initialize, and validate
terraform fmt -recursive
terraform init
terraform validate

# 2. Preview changes
terraform plan

# 3. Apply infrastructure
terraform apply
```

---

## 📤 Outputs

Once applied, run:

```bash
terraform output
```

You will see:
- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `eks_cluster_name`
- `eks_cluster_endpoint`
- `fargate_profile_name`
- `argocd_admin_password_cmd`
- `argocd_server_url`

## 🔗 Access Argo CD UI Locally
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```
Then visit:

http://localhost:8080

Retrieve the admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```
## 📡 Access ClickHouse Locally
```bash
kubectl port-forward svc/clickhouse -n clickhouse 8123:8123
```
Then open:

http://localhost:8123

## 🛠️ CI/CD Deployment Strategy

This project uses a **multi-phase GitHub Actions pipeline** to provision infrastructure, bootstrap components like Prometheus and ClickHouse, and finalize runtime config via Terraform.

### 🚀 Deployment Phases

| Phase | Description |
|-------|-------------|
| **Phase 1 – Infra Apply** | Provisions EKS, IAM, Argo CD, etc. using `terraform apply -var="enable_postdeploy=false"` |
| **Phase 2 – Prometheus Bootstrap** | Installs Prometheus CRDs and applies Argo CD app via [`scripts/bootstrap-prometheus.sh`](scripts/bootstrap-prometheus.sh) |
| **Phase 3 – ClickHouse Bootstrap** | Waits for ClickHouse to be ready and applies initial DDL via [`scripts/bootstrap-clickhouse.sh`](scripts/bootstrap-clickhouse.sh) |
| **Phase 4 – Post Deploy** | Port-forwards ClickHouse to `localhost:8123` via [`scripts/portforward-clickhouse.sh`](scripts/portforward-clickhouse.sh), then runs `terraform apply -var="enable_postdeploy=true"` to configure users/roles, and restarts the ingestion service |

Each step runs in a separate GitHub Actions job and is orchestrated via dependencies defined in [`terraform-cd.yaml`](.github/workflows/terraform-cd.yaml).

---

## 🧰 Shell Script Overview

| Script | Purpose |
|--------|---------|
| [`scripts/bootstrap-prometheus.sh`](scripts/bootstrap-prometheus.sh) | Installs Prometheus CRDs and applies the `apps/prometheus.yaml` manifest |
| [`scripts/bootstrap-clickhouse.sh`](scripts/bootstrap-clickhouse.sh) | Waits for the ClickHouse pod to be running and applies SQL DDL from [`ddl/init.sql`](ddl/init.sql) |
| [`scripts/portforward-clickhouse.sh`](scripts/portforward-clickhouse.sh) | Starts a background port-forward to the ClickHouse pod, confirms availability via `curl`, and exits with error if not reachable |

All scripts are CI-safe and can also be executed locally to simulate end-to-end deploy behavior outside of GitHub Actions.

---

## 🗺️ CD Pipeline Diagram

```mermaid
flowchart TD
  A[Push to main] --> B[Terraform Apply - Infra]
  B --> C[Prometheus Bootstrap]
  B --> D[ClickHouse Bootstrap]
  C & D --> E[Terraform Apply - Post-Deploy]
  E --> F[Restart Ingestion Service]

  B:::job
  C:::job
  D:::job
  E:::job
  F:::job

  classDef job fill:#f0f9ff,stroke:#3b82f6,stroke-width:2px,color:#1e40af,font-weight:bold
```
---
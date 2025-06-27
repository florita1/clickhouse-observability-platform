# 🧠 ClickHouse Observability Platform (Terraform Phase)

This repository contains Terraform code for provisioning a production-ready AWS EKS environment to support a real-time observability platform built on ClickHouse, Grafana, Tempo, Loki, and Alloy. It serves as the infrastructure foundation for a GitOps-managed data and telemetry stack.

---

## 📁 Repo Structure

```
.
├── README.md
└── terraform
    ├── environments
    │   └── dev
    │       ├── eks.tf               # Wires in EKS module and node group config
    │       ├── iam.tf               # IAM roles and policy attachments for EKS and nodegroups
    │       ├── outputs.tf           # Outputs for cluster name, endpoint, etc.
    │       ├── providers.tf         # AWS provider configuration
    │       ├── variables.tf         # Environment-specific variables
    │       ├── vpc.tf             # VPC module wiring (subnets, routes, NAT, etc.)
    │       └── argocd.tf          # Argo CD GitOps deployment module
    └── modules
        ├── eks
        │   ├── main.tf              # EKS cluster, nodegroup, and Fargate profile
        │   ├── outputs.tf           # Exposes cluster name, endpoint, and Fargate details
        │   └── variables.tf         # Input variables for eks module
        ├── argocd
        │   ├── main.tf              # Argo CD Helm release and namespace setup
        │   ├── outputs.tf           # Admin login command, UI endpoint
        │   ├── values.yaml          # Argo CD config (insecure HTTP mode for local dev)
        └── vpc
            ├── main.tf              # VPC, subnets, NAT gateways, route tables
            ├── outputs.tf           # Exposes subnet and VPC IDs
            └── variables.tf         # Input variables for vpc module
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
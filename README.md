# 🧠 ClickHouse Observability Platform (Terraform Phase)

This repository contains Terraform code for provisioning a production-grade AWS EKS cluster with modular VPC, IAM, and Kubernetes components. It serves as the foundational infrastructure for deploying ClickHouse, Grafana, Tempo, and related observability tools.

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
    │       └── vpc.tf               # Wires in VPC module
    └── modules
        ├── eks
        │   ├── main.tf              # EKS cluster, nodegroup, and Fargate profile
        │   ├── outputs.tf           # Exposes cluster name, endpoint, and Fargate details
        │   └── variables.tf         # Input variables for eks module
        └── vpc
            ├── main.tf              # VPC, subnets, NAT gateways, route tables
            ├── outputs.tf           # Exposes subnet and VPC IDs
            └── variables.tf         # Input variables for vpc module
```

---

## 🚀 What This Phase Does

This portion of the project provisions:

- A **multi-AZ VPC** with:
  - Public and private subnets
  - Route tables and associations
  - Internet Gateway (IGW)
  - NAT Gateway(s) with EIPs
- Output values used by later phases (e.g., EKS, observability stack)

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
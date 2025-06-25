# 🧠 ClickHouse Observability Platform (Terraform Phase)

This project provisions foundational AWS infrastructure for a real-time OLAP observability stack using **modular Terraform**. It is part of a larger initiative to simulate SaaS-style GitOps and telemetry ingestion pipelines for ClickHouse.

---

## 📁 Repo Structure

```
.
├── README.md                     # This file
└── terraform/
    ├── environments/
    │   └── dev/
    │       ├── main.tf           # Root module for the dev environment
    │       ├── outputs.tf        # Re-exports values from VPC module
    │       └── variables.tf      # Input values for the dev environment
    └── modules/
        └── vpc/
            ├── main.tf           # Provisions VPC, subnets, NAT, IGW
            ├── outputs.tf        # VPC outputs (vpc_id, subnets)
            └── variables.tf      # Configurable inputs (CIDR, AZ count, tags)
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

## 📦 Remote State with S3 and DynamoDB

This project uses **Terraform remote state** to securely store infrastructure state and enable team-safe operations.

### 🪣 S3 Backend

Terraform state is stored in a versioned and encrypted S3 bucket:

- **Bucket**: `clickhouse-observability-tf-state`
- **Key**: `dev/terraform.tfstate`
- **Region**: `us-east-1`

### 🔒 DynamoDB State Locking

To prevent simultaneous modifications to the state file, a DynamoDB table named `terraform-locks` is used for **state locking** and **consistency**.

---

## 🛠️ One-Time Setup

Before working in the `dev` environment, provision the backend infrastructure:

```bash
cd terraform/backend-setup
terraform init
terraform apply
```

This will create the required S3 bucket and DynamoDB table for remote state management.

---

## 🚀 Initialize Remote State in `dev`

Once the backend is provisioned, initialize the remote backend:

```bash
cd terraform/environments/dev
terraform init -reconfigure
```

This will migrate your local `.tfstate` to S3 and enable locking via DynamoDB.

---

## 🧹 Cleanup Local State

After migration, you can safely delete any local `.tfstate` files:

```bash
rm terraform.tfstate*
```

Also ensure `.gitignore` contains the following entries to prevent accidental commits:

```gitignore
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
```

---

## 🔐 AWS Credentials

Make sure Terraform has access to AWS credentials via one of the following:

- `~/.aws/credentials` (local development)
- Environment variables:  
  `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- GitHub Actions secrets (for CI/CD pipelines)

---

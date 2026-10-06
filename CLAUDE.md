# Terraform Multi-Account Infrastructure Repository

## Project Overview

This repository manages AWS multi-account infrastructure across 3 AWS accounts using Terraform. It defines and deploys core networking, transit gateway connectivity, VPC endpoints, and Kubernetes clusters (EKS) across multiple regions.

**Key Infrastructure:**
- **Transit Gateway (TGW)** — Hub-and-spoke network connectivity across accounts/regions
- **VPCs** — Isolated networks in each account-region combination
- **VPC Endpoints** — AWS service access without internet transit
- **EKS Clusters** — Kubernetes workload platform (dev-apne2)

## AWS Accounts

| Account | ID | Purpose | Terraform Role |
|---------|-----|---------|------------------|
| `manage` | 692806374063 | Hub/management (TGW hub) | `ManageTerraformRole` |
| `dev` | 558846430793 | Development workloads | `DevTerraformRole` |
| `shared` | 202949997891 | Shared services, GitLab Runner | `SharedTerraformRole` |

## Deployment Architecture

**GitLab Runner Setup (shared account):**
```
GitLab Runner (202949997891)
  └── GitlabTerraformRole (Pod Identity)
        ├── assume → ManageTerraformRole
        ├── assume → DevTerraformRole
        └── assume → SharedTerraformRole
```

**Local Mac Development:**
```
IAM User (Byoungsoo @ 558846430793)
  ├── assume → ManageTerraformRole
  ├── assume → DevTerraformRole
  └── assume → SharedTerraformRole
```

All Terraform operations assume cross-account roles to deploy into target accounts.

## Repository Structure

```
terraform/
├── account/                              # Account-specific Terraform configs
│   ├── aws-{env}-{region}/              # e.g., aws-dev-apne2, aws-manage-use1
│   │   ├── vpc/                         # VPC and subnets
│   │   ├── tgw/                         # Transit Gateway configuration
│   │   ├── vpc-endpoint/                # VPC endpoints (S3, DynamoDB, etc.)
│   │   └── eks-tf/                      # EKS cluster (dev-apne2 only)
│   │
│   ├── aws-dev-use1/
│   ├── aws-dev-apne2/
│   ├── aws-dev-apne3/
│   ├── aws-manage-use1/
│   ├── aws-manage-apne2/
│   └── aws-manage-apne3/
│
├── module/                               # Terraform modules (local)
│   └── module-vpc/
│
├── .gitlab-ci/                           # Pipeline jobs per account/region
│   ├── dev-ap2.yml
│   ├── dev-ap3.yml
│   ├── dev-ue1.yml
│   ├── manage-ap2.yml
│   ├── manage-ap3.yml
│   └── manage-ue1.yml
│
├── .gitlab-ci.yml                        # Main CI/CD pipeline (includes per-region)
├── README.md                             # Architecture diagrams and network overview
└── CLAUDE.md                             # This file
```

## Naming Conventions

**See `/Users/bys/.claude/rules/terraform-generator-conventions.md` for complete rules.**

### Quick Reference

**Standard Resources:**
```
{project_code}-{account}-{region_code}-{resource_type}-{name}
```

Example: `bys-dev-apne2-vpc-main`, `bys-dev-apne2-sbn-1d-db`

- `project_code` = `bys` (always)
- `account` = `dev` | `manage` | `shared`
- `region_code` = AWS AZ ID prefix: `use1`, `apne2`, `apne3`
- `resource_type` = `vpc`, `sbn`, `tgw`, `sg`, `eks`, etc.

**Region Codes (from AWS AZ ID):**
| Code | Region | Regions |
|------|--------|---------|
| `use1` | us-east-1 | Virginia |
| `apne2` | ap-northeast-2 | Seoul |
| `apne3` | ap-northeast-3 | Osaka |

**IAM Roles & Policies (Exception — PascalCase):**
```
{Service/Feature}Role / {Service/Feature}Policy
```

Examples: `KarpenterControllerRole`, `AdminDevAccountRole`, `AmazonEKSWorkerNodeRole`

IAM resource names are human-readable and do NOT include account/region/project prefixes.

## File Structure per Component

Each component (vpc, tgw, eks-tf, vpc-endpoint) follows:

```
{component}/
├── provider.tf              # Provider config + backend S3
├── main.tf                  # Primary resources and module calls
├── output.tf                # Output values
├── versions.tf              # Terraform + provider version requirements
├── var.default.tf           # Common variables (project_code, account, region, common_tags)
├── var.{component}.tf       # Component-specific variable declarations
├── var.{component}.auto.tfvars  # Default variable values (auto-loaded)
├── {purpose}.tf             # Purpose-specific files (e.g., tgw-peering.tf, addons.tf)
└── environments/
    └── {env}.tfvars         # Environment-specific overrides (not commonly used)
```

## Network Design

**VPC CIDR Blocks:**

| Account-Region | CIDR | Notes |
|---|---|---|
| manage-use1 | 10.5.0.0/16 | Primary + secondary 100.64.0.0/16 |
| manage-apne2 | 10.0.0.0/16 | |
| manage-apne3 | 10.3.0.0/16 | |
| dev-apne2 | 10.20.0.0/16 | |
| dev-apne3 | 10.30.0.0/16 | |
| dev-use1 | 10.25.0.0/16 | |
| shared-apne2 | 10.10.0.0/16 | |

**Subnet Architecture:**

Each VPC has subnets by type:
- `dmz` — Public (IGW route)
- `extelb` — Public (External LB)
- `app` — Private (Karpenter nodes)
- `intelb` — Private (Internal LB)
- `db` — Private (Databases)
- `prvonly` — Private (No NAT)

Subnet CIDR: `/24` for most, `/21` for `app` (Karpenter)

**Transit Gateway Topology:**

TGW hub-and-spoke in `manage` account:
- `manage-use1 TGW` (ASN 64512) — US hub
- `manage-apne2 TGW` (ASN 64533) — Asia-Pacific hub
- `manage-apne3 TGW` (ASN 64534) — Osaka hub

TGW peering for cross-region connectivity:
- `manage-use1` ←→ `manage-apne2` (direct)
- `manage-apne2` ←→ `manage-apne3` (direct)
- `manage-use1` ←→ `manage-apne3` (via apne2 hub)

## Backend Configuration

**S3 Terraform State:**

- **Bucket:** `bys-shared-apne2-s3-terraform` (shared account)
- **Encryption:** Enabled (SSE-S3)
- **Region:** ap-northeast-2

**State Key Pattern:**

```
aws-{env}-{region_code}/common/{component}/terraform.tfstate
```

Examples:
- `aws-dev-apne2/common/vpc/terraform.tfstate`
- `aws-manage-use1/common/tgw/terraform.tfstate`
- `aws-dev-apne2/common/eks/terraform.tfstate`

## CI/CD Pipeline

**GitLab CI/CD Stages:**
1. **validate** — `terraform validate` each component
2. **plan** — `terraform plan` each component
3. **apply** — `terraform apply` (manual approval)

**Pipeline Jobs:**
- One job per account-region combination (6 total)
- Each includes validate, plan, apply stages
- Configured in `.gitlab-ci/{account}-{region}.yml`

**How to Run:**
1. Push changes to main branch
2. GitLab automatically runs validate/plan
3. Review plan output in merge request or pipeline
4. Manually approve apply stage (stored in `.gitlab-ci/`)

## Common Tasks

### Deploy a new component to an account

1. Create directory: `account/aws-{env}-{region}/{component}/`
2. Add standard files: `provider.tf`, `main.tf`, `var.default.tf`, `var.{component}.tf`, `var.{component}.auto.tfvars`
3. Update backend key to match component name
4. Set Terraform variables (account, region_code, aws_region)
5. Define resources following naming conventions (§3 in conventions.md)

### Modify networking (VPC/subnet)

1. Edit `account/aws-{env}-{region}/vpc/main.tf` or `vpc_subnet.tf`
2. Update subnets, routes, or CIDR blocks
3. Run `terraform plan` to review changes
4. Push and approve apply stage

### Add cross-account/cross-region connectivity

1. Edit TGW configuration: `account/aws-manage-{region}/tgw/tgw.tf` or `tgw-peering.tf`
2. Use provider aliases for cross-account/region access
3. Create TGW attachments and routing as needed

### Update EKS cluster

1. Edit `account/aws-dev-apne2/eks-tf/main.tf`
2. Modify cluster add-ons, node groups, or IAM roles
3. Follow EKS best practices and role naming (§3.1 in conventions.md)

## Development Workflow

**Local Development:**
```bash
# 1. Assume role (if needed)
aws sts assume-role --role-arn arn:aws:iam::ACCOUNT:role/ROLE --role-session-name terraform

# 2. Navigate to component
cd account/aws-{env}-{region}/{component}

# 3. Initialize and plan
terraform init
terraform plan -var-file=var.{component}.auto.tfvars

# 4. Review and apply
terraform apply -var-file=var.{component}.auto.tfvars
```

**Git Commit:**
```bash
# Use the provided commit.sh script
./commit.sh "fix: update VPC routes for dev-apne2"

# Or commit manually with proper attribution
git commit -m "feat: add new TGW attachment

- Details
- More details

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"
```

## Important Notes

1. **Always follow naming conventions** — Consistency across 3 accounts is critical for automation and discoverability
2. **Backend state isolation** — Each component has its own tfstate file; do not mix components
3. **Cross-account assumptions** — All assume-role operations require trust relationships in target account IAM policies
4. **GitLab Runner identity** — Ensure GitlabTerraformRole has permissions to assume dev/manage/shared roles
5. **No sensitive data in git** — Use Terraform variables and AWS Secrets Manager for credentials
6. **Test in dev first** — Always validate changes in dev account before applying to manage/shared

## Related Documentation

- **Conventions & Naming:** `/Users/bys/.claude/rules/terraform-generator-conventions.md`
- **Architecture Overview:** `README.md` (with TGW topology diagrams)
- **AWS Documentation:** See backend.tf and provider.tf for service URLs

## Tools & Commands

- **Terraform:** v1.14.5 (per GitLab CI/CD TF_VERSION)
- **Provider:** AWS Terraform Provider ≥ 5.0
- **State:** S3 backend with encryption
- **CI/CD:** GitLab with Terraform Docker image

---

Last updated: 2026-10-06

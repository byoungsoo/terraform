# EKS Main Cluster - Terraform Configuration

## Overview
This directory contains Terraform configuration for deploying an EKS cluster in the dev environment.

## Directory Structure
```
.
├── main.tf                    # EKS cluster resources
├── addons.tf                  # EKS addons configuration
├── provider.tf                # AWS provider configuration
├── variables.tf               # Variable declarations
├── versions.tf                # Terraform and provider versions
├── output.tf                  # Output values
├── environments/              # Environment-specific configurations (Git tracked)
│   └── dev.tfvars            # Non-sensitive dev configuration
└── secrets/                   # Sensitive information (Git ignored)
    ├── dev.secret.tfvars     # Actual sensitive values (DO NOT COMMIT)
    └── example.secret.tfvars # Template for secret values (Git tracked)
```

## Setup Instructions

### 1. Clone Repositories
```bash
# Clone both repositories in the same parent directory
git clone git@github.com:YOUR_ORG/terraform-infra.git
git clone git@github.com:YOUR_ORG/terraform-secrets.git

# Directory structure:
workspace/
├── terraform-infra/
└── terraform-secrets/
```

### 2. Initialize Terraform
```bash
cd terraform-infra/account/aws-dev-ap2/eks-main
terraform init
```

### 3. Plan Changes (Using Makefile)
```bash
# Simple way
make plan

# Or specify environment
make plan ENV=dev
```

### 4. Apply Changes
```bash
make apply
```

### Alternative: Without Makefile
```bash
terraform plan \
  -var-file="environments/dev.tfvars" \
  -var-file="../../../../terraform-secrets/aws-dev-ap2/eks-main/dev.secret.tfvars"

terraform apply \
  -var-file="environments/dev.tfvars" \
  -var-file="../../../../terraform-secrets/aws-dev-ap2/eks-main/dev.secret.tfvars"
```

## Variable Files

### environments/dev.tfvars (This Repo)
Contains non-sensitive configuration:
- Project metadata
- EKS cluster version
- Node group configuration
- Addon versions
- Tags

### secrets/dev.secret.tfvars (Separate Private Repo)
Contains sensitive information stored in `terraform-secrets` repository:
- AWS Account IDs (in ARNs)
- VPC IDs
- Subnet IDs
- IAM Role ARNs
- User names

**Note**: The `secrets/` directory in this repo contains only example templates.
Actual secret files are managed in a separate private repository.

## Security Notes

⚠️ **IMPORTANT**: Never commit `secrets/*.secret.tfvars` files to Git!

The `.gitignore` file is configured to exclude:
- `secrets/*.secret.tfvars`
- `*.tfstate` files
- `.terraform/` directory

## Adding New Environments

To add staging or production:

1. Create environment config:
```bash
cp environments/dev.tfvars environments/staging.tfvars
# Edit staging.tfvars with staging-specific values
```

2. Create secret config:
```bash
cp secrets/example.secret.tfvars secrets/staging.secret.tfvars
# Fill in staging AWS resources
```

3. Deploy:
```bash
terraform workspace new staging
terraform plan -var-file="environments/staging.tfvars" -var-file="secrets/staging.secret.tfvars"
```

## Resource Naming Convention
```
${project_code}-${account}-${aws_region_code}-resource-{az}-{name}

Example: bys-dev-ap2-eks-main
```

## Outputs
After successful deployment, Terraform will output:
- EKS cluster endpoint
- EKS cluster security group ID
- OIDC provider ARN
- Node group details

terraform {
  backend "s3" {
    bucket  = "bys-shared-ap2-s3-terraform"
    key     = "aws-dev-ap2/eks-tf/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  # profile = "dev-admin"

  assume_role {
    role_arn = "arn:aws:iam::558846430793:role/DevTerraformRole"
  }

  default_tags {
    tags = var.common_tags
  }
}

# Resource Naming Rule
# ${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

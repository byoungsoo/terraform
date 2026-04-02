terraform {

  backend "s3" {
    bucket  = "bys-shared-ap2-s3-terraform"
    key     = "aws-manage-ap2/vpc/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
    profile = "shared-admin"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
  profile = "managed-admin"
}

# Resource Naming Rule
#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

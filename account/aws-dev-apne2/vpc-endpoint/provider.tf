terraform {

  backend "s3" {
    bucket  = "bys-shared-apne2-s3-terraform"
    key     = "aws-dev-apne2/vpc-endpoint/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
  # profile = "dev-admin"

  assume_role {
    role_arn = "arn:aws:iam::558846430793:role/DevTerraformRole"
  }
}

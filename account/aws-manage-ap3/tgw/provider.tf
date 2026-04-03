terraform {

  backend "s3" {
    bucket  = "bys-shared-ap2-s3-terraform"
    key     = "aws-manage-ap3/tgw/terraform.tfstate"
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
  region = "ap-northeast-3"
  # profile = "managed-admin"

  assume_role {
    role_arn = "arn:aws:iam::692806374063:role/ManageTerraformRole"
  }
}

provider "aws" {
  alias  = "dev-ap3"
  region = "ap-northeast-3"
  # profile = "dev-admin"

  assume_role {
    role_arn = "arn:aws:iam::558846430793:role/DevTerraformRole"
  }
}

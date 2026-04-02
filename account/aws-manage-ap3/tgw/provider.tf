terraform {

  backend "s3" {
    bucket  = "bys-shared-ap2-s3-terraform"
    key     = "aws-manage-ap3/tgw/terraform.tfstate"
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
  region  = "ap-northeast-3"
  profile = "managed-admin"
}

provider "aws" {
  alias   = "dev-ap3"
  region  = "ap-northeast-3"
  profile = "dev-admin"
}

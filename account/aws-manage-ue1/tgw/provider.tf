terraform {

  backend "s3" {
    bucket  = "bys-shared-ap2-s3-terraform"
    key     = "aws-manage-ue1/tgw/terraform.tfstate"
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
  region = "us-east-1"
  profile = "managed-admin"
}

# Resource Naming Rule
provider "aws" {
  alias  = "dev-ue1"
  region = "us-east-1"
  profile = "dev-admin"
}

provider "aws" {
  alias  = "dev-ap2"
  region = "ap-northeast-2"
  profile = "dev-admin"
  
}

provider "aws" {
  alias  = "shared-ap2"
  region = "ap-northeast-2"
  profile = "shared-admin"
}
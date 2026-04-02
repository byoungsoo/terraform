terraform {
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
  profile = "dev-admin"
  
}

provider "aws" {
  alias  = "manage-ue1"
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
  alias  = "shared-ap2"
  region = "ap-northeast-2"
  profile = "shared-admin"
}
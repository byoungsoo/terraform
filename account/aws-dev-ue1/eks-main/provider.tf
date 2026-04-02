terraform {

  backend "s3" {
    bucket  = "bys-shared-ap2-s3-terraform"
    key     = "aws-dev-ue1/eks-main/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
    profile = "shared-admin"
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

provider "aws" {
  region  = "us-east-1"
  profile = "dev-admin"
}

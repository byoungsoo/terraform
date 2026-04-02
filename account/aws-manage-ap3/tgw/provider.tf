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
  region  = "ap-northeast-3"
  profile = "managed-admin"
}

provider "aws" {
  alias   = "dev-ap3"
  region  = "ap-northeast-3"
  profile = "dev-admin"
}

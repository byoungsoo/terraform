terraform {

  backend "s3" {
    bucket  = "bys-shared-apne2-s3-terraform"
    key     = "aws-manage-apne2/common/tgw/terraform.tfstate"
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
  # profile = "managed-admin"

  assume_role {
    role_arn = "arn:aws:iam::692806374063:role/ManageTerraformRole"
  }
}

provider "aws" {
  alias  = "dev-apne2"
  region = "ap-northeast-2"
  # profile = "dev-admin"

  assume_role {
    role_arn = "arn:aws:iam::558846430793:role/DevTerraformRole"
  }
}

provider "aws" {
  alias  = "shared-apne2"
  region = "ap-northeast-2"
  # profile = "shared-admin"

  assume_role {
    role_arn = "arn:aws:iam::202949997891:role/SharedTerraformRole"
  }
}

provider "aws" {
  alias  = "manage-use1"
  region = "us-east-1"
  # profile = "managed-admin"

  assume_role {
    role_arn = "arn:aws:iam::692806374063:role/ManageTerraformRole"
  }
}

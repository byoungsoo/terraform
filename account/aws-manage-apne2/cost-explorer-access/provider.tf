terraform {
  backend "s3" {
    bucket  = "bys-shared-apne2-s3-terraform"
    key     = "aws-manage-apne2/common/cost-explorer-access/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::692806374063:role/ManageTerraformRole"
  }
}

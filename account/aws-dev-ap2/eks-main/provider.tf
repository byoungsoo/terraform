# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = "dev-admin"

  default_tags {
    tags = var.common_tags
  }
}

# Resource Naming Rule
# ${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

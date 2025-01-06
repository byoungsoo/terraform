locals {
  # Resource Naming Rule
  #${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
  project_code = "bys"
  account = "dev"
  aws_region = "us-east-1"
  aws_region_code = "ue1"
}

# dev/ec2/data.tf

data "terraform_remote_state" "manage_ue1" {
	backend = "local" {
    	path = "../../aws-manage-ue1/vpc/terraform.tfstate"
    }
}
data "terraform_remote_state" "dev_ue1" {
	backend = "local" {
    	path = "../../aws-dev-ue1/vpc/terraform.tfstate"
    }
}

locals {
  manage_ue1_vpc_id = data.terraform_remote_state.manage_ue1.outputs.vpc_id
  manage_ue1_subnet_ids = data.terraform_remote_state.manage_ue1.outputs.private_subnet_ids

  # manage_ap2_vpc_id = ""
  # manage_ap2_subnet_ids = []

  dev_ue1_vpc_id = data.terraform_remote_state.dev_ue1.outputs.vpc_id
  dev_ue1_subnet_ids = data.terraform_remote_state.manage_ue1.outputs.private_subnet_ids

  dev_ap2_vpc_id = "vpc-0ca96cd5c37d3bae8"
  dev_ap2_subnet_ids = []

}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.0"

  name        = "${local.project_code}-${local.account}-${local.aws_region_code}--tgw-main"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id       = module.vpc.vpc_id
      subnet_ids   = module.vpc.private_subnets
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole = true
          destination_cidr_block = "40.0.0.0/20"
        }
      ]
    }
  }

  ram_allow_external_principals = true
  ram_principals = [307990089504]

  tags = {
    Purpose = "tgw-complete-example"
  }
}


locals {
  # Resource Naming Rule
  #${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
  project_code = "bys"
  account = "dev"
  aws_region = "ap-northeast-2"
  aws_region_code = "ap2"

  ## dev-ap2
  dev_ap2 = {
    vpc_id = "vpc-0ca96cd5c37d3bae8"
    subnet_ids = [
      "subnet-0bbd4c134a3589aee",
      "subnet-0905f706c84047310",
      "subnet-0299d5e7a4d5b7615",
      "subnet-011d63d192c05c6a3",
    ]
    private_route_table_ids = [
      "rtb-04a58feb2f450f59e"
    ]
  }
}

## Module - dev-ap2 attachment to manage-ap2 TGW
## NOTE: tgw_id is hardcoded - ensure manage-ap2 TGW is created and RAM share is accepted first
module "dev_ap2_tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 3.0"

  name        = "bys-manage-ap2-tgw-attachment-dev-ap2"
  description = "dev-ap2 VPC attachment to manage-ap2 TGW"
  amazon_side_asn = 64534

  create_tgw             = false
  share_tgw              = false
  
  # Use RAM share from manage-ap2 TGW
  # IMPORTANT: RAM share must be accepted before running this
  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc_dev_ap2 = {
      tgw_id       = "tgw-0e2b2336834fa87c7"  # manage-ap2 TGW (shared via RAM)
      vpc_id       = local.dev_ap2.vpc_id
      subnet_ids   = local.dev_ap2.subnet_ids
      
      dns_support  = true
      enable_sg_referencing_support = true
      ipv6_support = false

      vpc_route_table_ids  = local.dev_ap2.private_route_table_ids
      tgw_destination_cidr = "10.0.0.0/8"  # Route all 10.x traffic to TGW
    }
  }

  tags = {
    Name = "bys-manage-ap2-tgw-attachment-dev-ap2"
    auto-delete = "no"
  }
}


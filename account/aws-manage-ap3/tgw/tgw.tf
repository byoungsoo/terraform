locals {
  # Resource Naming Rule
  #${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
  project_code    = "bys"
  account         = "manage"
  aws_region      = "ap-northeast-3"
  aws_region_code = "ap3"

  ## manage-ap3
  manage_ap3 = {
    vpc_id = "vpc-0afd0a26db53f359c"
    subnet_ids = [
      "subnet-0ab3180e4e599ba15", # prvonly-3a
      "subnet-0b769a6c689b752bd", # prvonly-3b
      "subnet-08c727790354ee7bc", # prvonly-3c
    ]
    private_route_table_ids = [
      "rtb-00e60b081d21668e6"
    ]
    public_route_table_ids = [
      "rtb-0a3b2b72fc2e150cf"
    ]
  }

  dev_ap3 = {
    vpc_id = "vpc-08c081812fdc76212"
    subnet_ids = [
      "subnet-0c37ff000861173bc", # prvonly-3a
      "subnet-091cb0b0e23599c78", # prvonly-3b
      "subnet-0b362458128024807", # prvonly-3c
    ]
    private_route_table_ids = [
      "rtb-0bfeb739447ca2ede"
    ]
    public_route_table_ids = [
      "rtb-0b3d1a83396e4ee64"
    ]
  }
}

## ============================================================================
## Transit Gateway
## ============================================================================
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Transit Gateway for manage account in ap-northeast-3"
  amazon_side_asn                 = 64534
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-main"
    auto-delete = "no"
  }
}

## ============================================================================
## RAM Share - Share TGW with other accounts
## ============================================================================
resource "aws_ram_resource_share" "tgw" {
  name                      = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-main"
  allow_external_principals = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-main"
    auto-delete = "no"
  }
}

resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

resource "aws_ram_principal_association" "dev_account" {
  principal          = "558846430793"
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

## ============================================================================
## VPC Attachment - manage-ap3
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "manage_ap3" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.manage_ap3.vpc_id
  subnet_ids         = local.manage_ap3.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-manage-ap3"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Attachment - dev-ap3 (from dev account via RAM share)
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_ap3" {
  provider = aws.dev-ap3

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.dev_ap3.vpc_id
  subnet_ids         = local.dev_ap3.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-dev-ap3"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Routes - manage-ap3 to dev-ap3 (same region)
## ============================================================================
resource "aws_route" "manage_ap3_private_to_dev_ap3" {
  for_each = toset(local.manage_ap3.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.30.0.0/16" # dev-ap3 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap3,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap3
  ]
}

resource "aws_route" "manage_ap3_public_to_dev_ap3" {
  for_each = toset(local.manage_ap3.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.30.0.0/16" # dev-ap3 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap3,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap3
  ]
}

## ============================================================================
## VPC Routes - dev-ap3 to manage-ap3 (same region)
## ============================================================================
resource "aws_route" "dev_ap3_private_to_manage_ap3" {
  provider = aws.dev-ap3
  for_each = toset(local.dev_ap3.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.3.0.0/16" # manage-ap3 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap3,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap3
  ]
}

resource "aws_route" "dev_ap3_public_to_manage_ap3" {
  provider = aws.dev-ap3
  for_each = toset(local.dev_ap3.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.3.0.0/16" # manage-ap3 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap3,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap3
  ]
}

## ============================================================================
## Outputs
## ============================================================================
output "tgw_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "tgw_arn" {
  description = "Transit Gateway ARN"
  value       = aws_ec2_transit_gateway.main.arn
}

output "tgw_default_route_table_id" {
  description = "Default Route Table ID"
  value       = aws_ec2_transit_gateway.main.association_default_route_table_id
}

output "ram_resource_share_id" {
  description = "RAM Resource Share ID"
  value       = aws_ram_resource_share.tgw.id
}

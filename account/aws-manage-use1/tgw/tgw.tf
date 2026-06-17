locals {
  # Resource Naming Rule
  #${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
  project_code    = "bys"
  account         = "manage"
  aws_region      = "us-east-1"
  aws_region_code = "use1"

  ## manage-use1
  manage_use1 = {
    vpc_id = "vpc-0e72171581e48f648"
    subnet_ids = [
      "subnet-045e8ae0adf010652",
      "subnet-0b689d1f39d89a691",
      "subnet-0ab893ff84c9ff1e7",
      "subnet-05f0625241b849822",
      "subnet-0880ed366db745bfd",
      "subnet-085e04b6253a9ab92"
    ]
    private_route_table_ids = [
      "rtb-0376c2be563b9e54a"
    ]
    public_route_table_ids = [
      "rtb-009eb1218e725dffd"
    ]
  }

  dev_use1 = {
    vpc_id = "vpc-012e100b29d364995"
    subnet_ids = [
      "subnet-04291fc384bf08c8c",
      "subnet-0b1e027d00f39d765",
      "subnet-082db326c9b13f5e6",
      "subnet-0ed7d6d7dd9e41ce4",
      "subnet-031cdc214322da2dd",
      "subnet-0c7f1a6209a63d9cb",
    ]
    private_route_table_ids = [
      "rtb-010c20126d841b5c1"
    ]
    public_route_table_ids = [
      "rtb-0415e0cad88c36d86"
    ]
  }
}

## ============================================================================
## Transit Gateway
## ============================================================================
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Transit Gateway for manage account in us-east-1"
  amazon_side_asn                 = 64512
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

resource "aws_ram_principal_association" "shared_account" {
  principal          = "202949997891"
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

## ============================================================================
## VPC Attachment - manage-use1
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "manage_use1" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.manage_use1.vpc_id
  subnet_ids         = local.manage_use1.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-manage-use1"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Attachment - dev-use1 (from dev account via RAM share)
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_use1" {
  provider = aws.dev-use1

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.dev_use1.vpc_id
  subnet_ids         = local.dev_use1.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-dev-use1"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Routes - manage-use1 private subnets (same region only)
## ============================================================================
resource "aws_route" "manage_use1_private_to_dev_use1" {
  for_each = toset(local.manage_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.25.0.0/16" # dev-use1 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_vpc_attachment.dev_use1
  ]
}

## ============================================================================
## VPC Routes - manage-use1 public subnets (same region only)
## ============================================================================
resource "aws_route" "manage_use1_public_to_dev_use1" {
  for_each = toset(local.manage_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.25.0.0/16" # dev-use1 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_vpc_attachment.dev_use1
  ]
}

## ============================================================================
## VPC Routes - dev-use1 private subnets (same region only)
## ============================================================================
resource "aws_route" "dev_use1_private_to_manage_use1" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.5.0.0/16" # manage-use1 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_vpc_attachment.dev_use1
  ]
}

## ============================================================================
## VPC Routes - dev-use1 public subnets (same region only)
## ============================================================================
resource "aws_route" "dev_use1_public_to_manage_use1" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.5.0.0/16" # manage-use1 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_vpc_attachment.dev_use1
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

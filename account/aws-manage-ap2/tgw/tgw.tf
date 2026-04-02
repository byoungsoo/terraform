locals {
  # Resource Naming Rule
  #${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
  project_code    = "bys"
  account         = "manage"
  aws_region      = "ap-northeast-2"
  aws_region_code = "ap2"

  ## manage-ap2
  manage_ap2 = {
    vpc_id = "vpc-0757c82cafd8aa10b"
    subnet_ids = [
      "subnet-09003e4414ce9ae02", # prvonly-2a
      "subnet-0045da1b45bc5a825", # prvonly-2b
      "subnet-0d1afb5eeeeb843d8", # prvonly-2c
      "subnet-0d2a9a2e5c0886c38", # prvonly-2d
    ]
    private_route_table_ids = [
      "rtb-0949919db24270991"
    ]
    public_route_table_ids = [
      "rtb-03aaeec1a8c3a15cb"
    ]
  }

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
    public_route_table_ids = [
      "rtb-07f2da51755e6c5d8"
    ]
  }

  shared_ap2 = {
    vpc_id = "vpc-01a3e793dd47f6e1c"
    subnet_ids = [
      "subnet-004669fa5ae85e0ee",  # bys-shared-sbn-az1-app (ap-northeast-2a)
      "subnet-071a86fe48af636ac",  # bys-shared-sbn-az3-app (ap-northeast-2c)
    ]
    private_route_table_ids = [
      "rtb-0518abbad39919632"  # bys-shared-rtb-private
    ]
    public_route_table_ids = [
      "rtb-00ee43a0e1233e3a0"  # bys-shared-rtb-public
    ]
  }
}

## ============================================================================
## Transit Gateway
## ============================================================================
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Transit Gateway for manage account in ap-northeast-2"
  amazon_side_asn                 = 64533
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
## VPC Attachment - manage-ap2
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "manage_ap2" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.manage_ap2.vpc_id
  subnet_ids         = local.manage_ap2.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-manage-ap2"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Attachment - dev-ap2 (from dev account via RAM share)
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_ap2" {
  provider = aws.dev-ap2

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.dev_ap2.vpc_id
  subnet_ids         = local.dev_ap2.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-dev-ap2"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Attachment - shared-ap2 (from shared account via RAM share)
## ============================================================================
resource "aws_ec2_transit_gateway_vpc_attachment" "shared_ap2" {
  provider = aws.shared-ap2

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = local.shared_ap2.vpc_id
  subnet_ids         = local.shared_ap2.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-attach-shared-ap2"
    auto-delete = "no"
  }
}

## ============================================================================
## VPC Routes - manage-ap2 private subnets (same region only)
## ============================================================================
resource "aws_route" "manage_ap2_private_to_dev_ap2" {
  for_each = toset(local.manage_ap2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.20.0.0/16" # dev-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2
  ]
}

resource "aws_route" "manage_ap2_private_to_shared_ap2" {
  for_each = toset(local.manage_ap2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.10.0.0/16" # shared-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

## ============================================================================
## VPC Routes - manage-ap2 public subnets (same region only)
## ============================================================================
resource "aws_route" "manage_ap2_public_to_dev_ap2" {
  for_each = toset(local.manage_ap2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.20.0.0/16" # dev-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2
  ]
}

resource "aws_route" "manage_ap2_public_to_shared_ap2" {
  for_each = toset(local.manage_ap2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.10.0.0/16" # shared-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

## ============================================================================
## VPC Routes - dev-ap2 private subnets (same region only)
## NOTE: dev-ap2 is Legacy (CLI managed), but we add routes via Terraform
## ============================================================================
resource "aws_route" "dev_ap2_private_to_manage_ap2" {
  provider = aws.dev-ap2
  for_each = toset(local.dev_ap2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.0.0.0/16" # manage-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2
  ]
}

resource "aws_route" "dev_ap2_private_to_shared_ap2" {
  provider = aws.dev-ap2
  for_each = toset(local.dev_ap2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.10.0.0/16" # shared-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

## ============================================================================
## VPC Routes - dev-ap2 public subnets (same region only)
## ============================================================================
resource "aws_route" "dev_ap2_public_to_manage_ap2" {
  provider = aws.dev-ap2
  for_each = toset(local.dev_ap2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.0.0.0/16" # manage-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2
  ]
}

resource "aws_route" "dev_ap2_public_to_shared_ap2" {
  provider = aws.dev-ap2
  for_each = toset(local.dev_ap2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = "10.10.0.0/16" # shared-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

## ============================================================================
## VPC Routes - shared-ap2 private subnets (same region only)
## ============================================================================
resource "aws_route" "shared_ap2_private_to_manage_ap2" {
  provider = aws.shared-ap2
  for_each = length(local.shared_ap2.private_route_table_ids) > 0 ? toset(local.shared_ap2.private_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "10.0.0.0/16" # manage-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

resource "aws_route" "shared_ap2_private_to_dev_ap2" {
  provider = aws.shared-ap2
  for_each = length(local.shared_ap2.private_route_table_ids) > 0 ? toset(local.shared_ap2.private_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "10.20.0.0/16" # dev-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

resource "aws_route" "shared_ap2_public_to_manage_ap2" {
  provider = aws.shared-ap2
  for_each = length(local.shared_ap2.public_route_table_ids) > 0 ? toset(local.shared_ap2.public_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "10.0.0.0/16" # manage-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
  ]
}

resource "aws_route" "shared_ap2_public_to_dev_ap2" {
  provider = aws.shared-ap2
  for_each = length(local.shared_ap2.public_route_table_ids) > 0 ? toset(local.shared_ap2.public_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "10.20.0.0/16" # dev-ap2 VPC
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_ap2,
    aws_ec2_transit_gateway_vpc_attachment.shared_ap2
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

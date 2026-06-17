## ============================================================================
## TGW Peering - Cross Region Connection
## ============================================================================
## This file contains TGW peering configuration between us-east-1 and ap-northeast-2
## 
## Prerequisites:
## 1. Both TGWs must be created first (run tgw.tf in both regions)
## 2. Update peer_tgw_apne2_id with the actual TGW ID from ap2 region
##
## Deployment order:
## 1. Deploy this file in manage-use1 (creates peering request)
## 2. Deploy tgw-peering.tf in manage-apne2 (accepts peering)
## 3. Uncomment cross-region routes below after peering is accepted
## ============================================================================

locals {
  # Cross-region CIDR blocks
  manage_apne2_cidr = "10.0.0.0/16"
  dev_apne2_cidr    = "10.20.0.0/16"
  shared_apne2_cidr = "10.10.0.0/16"
  manage_apne3_cidr = "10.3.0.0/16"
  dev_apne3_cidr    = "10.30.0.0/16"

  # Peer TGW ID - UPDATE THIS after ap2 TGW is created
  # Get this from: cd account/aws-manage-apne2/tgw && terraform output tgw_id
  peer_tgw_apne2_id = "tgw-0cfb0f2b5f0bb3031"
}

## ============================================================================
## TGW Peering Attachment - Request from ue1 to ap2
## ============================================================================
resource "aws_ec2_transit_gateway_peering_attachment" "to_apne2" {
  count = local.peer_tgw_apne2_id != "" ? 1 : 0

  peer_region             = "ap-northeast-2"
  peer_transit_gateway_id = local.peer_tgw_apne2_id
  transit_gateway_id      = aws_ec2_transit_gateway.main.id

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-peering-to-apne2"
    auto-delete = "no"
    Side        = "Requester"
  }
}

## ============================================================================
## TGW Route Table Association - Peering
## NOTE: Skipped because default_route_table_association is enabled on TGW
## The peering attachment is automatically associated with the default route table
## ============================================================================
# resource "aws_ec2_transit_gateway_route_table_association" "peering_to_ap2" {
#   count = local.peer_tgw_apne2_id != "" ? 1 : 0
#
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
#
#   depends_on = [aws_ec2_transit_gateway_peering_attachment.to_apne2]
# }

## ============================================================================
## TGW Static Routes - Cross-region via peering
## IMPORTANT: Uncomment these AFTER peering is accepted in ap2 region
## ============================================================================

resource "aws_ec2_transit_gateway_route" "to_manage_apne2" {
  destination_cidr_block         = local.manage_apne2_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment.to_apne2
  ]
}

resource "aws_ec2_transit_gateway_route" "to_dev_apne2" {
  destination_cidr_block         = local.dev_apne2_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment.to_apne2
  ]
}

## ============================================================================
## VPC Routes - manage-use1 to ap2 region
## IMPORTANT: Uncomment these AFTER peering is accepted in ap2 region
## ============================================================================

resource "aws_route" "manage_use1_private_to_manage_apne2" {
  for_each = toset(local.manage_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_manage_apne2
  ]
}

resource "aws_route" "manage_use1_private_to_dev_apne2" {
  for_each = toset(local.manage_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_dev_apne2
  ]
}

resource "aws_route" "manage_use1_public_to_manage_apne2" {
  for_each = toset(local.manage_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_manage_apne2
  ]
}

resource "aws_route" "manage_use1_public_to_dev_apne2" {
  for_each = toset(local.manage_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_dev_apne2
  ]
}

## ============================================================================
## VPC Routes - dev-use1 to ap2 region
## IMPORTANT: Uncomment these AFTER peering is accepted in ap2 region
## ============================================================================

resource "aws_route" "dev_use1_private_to_manage_apne2" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_manage_apne2
  ]
}

resource "aws_route" "dev_use1_private_to_dev_apne2" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_dev_apne2
  ]
}

resource "aws_route" "dev_use1_public_to_manage_apne2" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_manage_apne2
  ]
}

resource "aws_route" "dev_use1_public_to_dev_apne2" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_dev_apne2
  ]
}

## ============================================================================
## Outputs
## ============================================================================
output "peering_attachment_id" {
  description = "TGW Peering Attachment ID (use this in ap2 accepter)"
  value       = local.peer_tgw_apne2_id != "" ? aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id : "Not created yet - update peer_tgw_apne2_id first"
}

output "peering_status" {
  description = "TGW Peering Status"
  value       = local.peer_tgw_apne2_id != "" ? "Peering request created" : "Not created yet"
}


## ============================================================================
## TGW Static Route - shared-apne2 via peering
## IMPORTANT: Uncomment this AFTER peering is accepted in ap2 region
## ============================================================================

resource "aws_ec2_transit_gateway_route" "to_shared_apne2" {
  destination_cidr_block         = local.shared_apne2_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment.to_apne2
  ]
}

## ============================================================================
## VPC Routes - manage-use1 to shared-apne2
## IMPORTANT: Uncomment these AFTER peering is accepted in ap2 region
## ============================================================================

resource "aws_route" "manage_use1_private_to_shared_apne2" {
  for_each = toset(local.manage_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.shared_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_shared_apne2
  ]
}

resource "aws_route" "manage_use1_public_to_shared_apne2" {
  for_each = toset(local.manage_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.shared_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_shared_apne2
  ]
}

## ============================================================================
## VPC Routes - dev-use1 to shared-apne2
## IMPORTANT: Uncomment these AFTER peering is accepted in ap2 region
## ============================================================================

resource "aws_route" "dev_use1_private_to_shared_apne2" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.shared_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_shared_apne2
  ]
}

resource "aws_route" "dev_use1_public_to_shared_apne2" {
  provider = aws.dev-use1
  for_each = toset(local.dev_use1.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.shared_apne2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_use1,
    aws_ec2_transit_gateway_peering_attachment.to_apne2,
    aws_ec2_transit_gateway_route.to_shared_apne2
  ]
}

## ============================================================================
## TGW Static Routes - to ap3 region VPCs via ap2 peering
## ============================================================================
resource "aws_ec2_transit_gateway_route" "to_manage_apne3" {
  destination_cidr_block         = local.manage_apne3_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_apne2]
}

resource "aws_ec2_transit_gateway_route" "to_dev_apne3" {
  destination_cidr_block         = local.dev_apne3_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_apne2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_apne2]
}

## ============================================================================
## VPC Routes - manage-use1 to ap3 region
## ============================================================================
resource "aws_route" "manage_use1_private_to_manage_apne3" {
  for_each               = toset(local.manage_use1.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "manage_use1_private_to_dev_apne3" {
  for_each               = toset(local.manage_use1.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

resource "aws_route" "manage_use1_public_to_manage_apne3" {
  for_each               = toset(local.manage_use1.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "manage_use1_public_to_dev_apne3" {
  for_each               = toset(local.manage_use1.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

## ============================================================================
## VPC Routes - dev-use1 to ap3 region
## ============================================================================
resource "aws_route" "dev_use1_private_to_manage_apne3" {
  provider               = aws.dev-use1
  for_each               = toset(local.dev_use1.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "dev_use1_private_to_dev_apne3" {
  provider               = aws.dev-use1
  for_each               = toset(local.dev_use1.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

resource "aws_route" "dev_use1_public_to_manage_apne3" {
  provider               = aws.dev-use1
  for_each               = toset(local.dev_use1.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "dev_use1_public_to_dev_apne3" {
  provider               = aws.dev-use1
  for_each               = toset(local.dev_use1.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

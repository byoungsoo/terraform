## ============================================================================
## TGW Peering - Cross Region Connection (ap3 → ap2)
## ============================================================================
## Deployment order:
## 1. Deploy tgw.tf in manage-ap3 first (creates TGW)
## 2. Deploy this file in manage-ap3 (creates peering request to ap2)
## 3. Deploy tgw-peering.tf in manage-ap2 (accepts peering from ap3)
## 4. After peering is accepted, routes become active
## ============================================================================

locals {
  # Cross-region CIDR blocks (reachable via ap2 TGW)
  manage_ap2_cidr = "10.0.0.0/16"
  dev_ap2_cidr    = "10.20.0.0/16"
  shared_ap2_cidr = "10.10.0.0/16"
  manage_ue1_cidr = "10.5.0.0/16"
  dev_ue1_cidr    = "10.25.0.0/16"

  # Peer TGW ID - manage-ap2 TGW
  # Get this from: cd account/aws-manage-ap2/tgw && terraform output tgw_id
  peer_tgw_ap2_id = "tgw-0cfb0f2b5f0bb3031"
}

## ============================================================================
## TGW Peering Attachment - Request from ap3 to ap2
## ============================================================================
resource "aws_ec2_transit_gateway_peering_attachment" "to_ap2" {
  count = local.peer_tgw_ap2_id != "" ? 1 : 0

  peer_region             = "ap-northeast-2"
  peer_transit_gateway_id = local.peer_tgw_ap2_id
  transit_gateway_id      = aws_ec2_transit_gateway.main.id

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-peering-to-ap2"
    auto-delete = "no"
    Side        = "Requester"
  }
}

## ============================================================================
## TGW Static Routes - to ap2 region VPCs via peering
## ============================================================================
resource "aws_ec2_transit_gateway_route" "to_manage_ap2" {
  destination_cidr_block         = local.manage_ap2_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_ap2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_ap2]
}

resource "aws_ec2_transit_gateway_route" "to_dev_ap2" {
  destination_cidr_block         = local.dev_ap2_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_ap2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_ap2]
}

resource "aws_ec2_transit_gateway_route" "to_shared_ap2" {
  destination_cidr_block         = local.shared_ap2_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_ap2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_ap2]
}

## TGW Static Routes - to ue1 region VPCs via ap2 peering (transitive via ap2)
resource "aws_ec2_transit_gateway_route" "to_manage_ue1" {
  destination_cidr_block         = local.manage_ue1_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_ap2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_ap2]
}

resource "aws_ec2_transit_gateway_route" "to_dev_ue1" {
  destination_cidr_block         = local.dev_ue1_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_ap2[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.to_ap2]
}

## ============================================================================
## VPC Routes - manage-ap3 to cross-region VPCs
## ============================================================================
resource "aws_route" "manage_ap3_private_to_manage_ap2" {
  for_each               = toset(local.manage_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ap2]
}

resource "aws_route" "manage_ap3_private_to_dev_ap2" {
  for_each               = toset(local.manage_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ap2]
}

resource "aws_route" "manage_ap3_private_to_shared_ap2" {
  for_each               = toset(local.manage_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.shared_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_shared_ap2]
}

resource "aws_route" "manage_ap3_private_to_manage_ue1" {
  for_each               = toset(local.manage_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ue1]
}

resource "aws_route" "manage_ap3_private_to_dev_ue1" {
  for_each               = toset(local.manage_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ue1]
}

resource "aws_route" "manage_ap3_public_to_manage_ap2" {
  for_each               = toset(local.manage_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ap2]
}

resource "aws_route" "manage_ap3_public_to_dev_ap2" {
  for_each               = toset(local.manage_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ap2]
}

resource "aws_route" "manage_ap3_public_to_shared_ap2" {
  for_each               = toset(local.manage_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.shared_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_shared_ap2]
}

resource "aws_route" "manage_ap3_public_to_manage_ue1" {
  for_each               = toset(local.manage_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ue1]
}

resource "aws_route" "manage_ap3_public_to_dev_ue1" {
  for_each               = toset(local.manage_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ue1]
}

## ============================================================================
## VPC Routes - dev-ap3 to cross-region VPCs
## ============================================================================
resource "aws_route" "dev_ap3_private_to_manage_ap2" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ap2]
}

resource "aws_route" "dev_ap3_private_to_dev_ap2" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ap2]
}

resource "aws_route" "dev_ap3_private_to_shared_ap2" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.shared_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_shared_ap2]
}

resource "aws_route" "dev_ap3_private_to_manage_ue1" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ue1]
}

resource "aws_route" "dev_ap3_private_to_dev_ue1" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ue1]
}

resource "aws_route" "dev_ap3_public_to_manage_ap2" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ap2]
}

resource "aws_route" "dev_ap3_public_to_dev_ap2" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ap2]
}

resource "aws_route" "dev_ap3_public_to_shared_ap2" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.shared_ap2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_shared_ap2]
}

resource "aws_route" "dev_ap3_public_to_manage_ue1" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.manage_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_manage_ue1]
}

resource "aws_route" "dev_ap3_public_to_dev_ue1" {
  provider               = aws.dev-ap3
  for_each               = toset(local.dev_ap3.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.dev_ue1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway_route.to_dev_ue1]
}

## ============================================================================
## Outputs
## ============================================================================
output "peering_attachment_id" {
  description = "TGW Peering Attachment ID (use this in ap2 accepter)"
  value       = local.peer_tgw_ap2_id != "" ? aws_ec2_transit_gateway_peering_attachment.to_ap2[0].id : "Not created yet - update peer_tgw_ap2_id first"
}

output "peering_status" {
  description = "TGW Peering Status"
  value       = local.peer_tgw_ap2_id != "" ? "Peering request created" : "Not created yet"
}

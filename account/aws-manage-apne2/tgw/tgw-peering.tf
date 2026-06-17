## ============================================================================
## TGW Peering - Cross Region Connection (Accepter Side)
## ============================================================================
## This file contains TGW peering accepter configuration for ap-northeast-2
## 
## Prerequisites:
## 1. Both TGWs must be created first (run tgw.tf in both regions)
## 2. Peering request must be created in ue1 first (run tgw-peering.tf in ue1)
## 3. Update peering_attachment_id with the actual attachment ID from ue1
##
## Deployment order:
## 1. Get peering attachment ID from ue1: terraform output peering_attachment_id
## 2. Update peering_attachment_id below
## 3. Deploy this file (accepts peering)
## 4. Uncomment cross-region routes below after peering is accepted
## ============================================================================

locals {
  # Cross-region CIDR blocks
  manage_use1_cidr = "10.5.0.0/16"
  dev_use1_cidr    = "10.25.0.0/16"
  shared_apne2_cidr = "10.10.0.0/16"
  manage_apne3_cidr = "10.3.0.0/16"
  dev_apne3_cidr    = "10.30.0.0/16"

  # Peering Attachment ID from ue1
  # Get this from: cd account/aws-manage-use1/tgw && terraform output peering_attachment_id
  peering_attachment_id = "tgw-attach-04e1d5bf35519c2f1"

  # Peering Attachment ID from ap3
  # Get this from: cd account/aws-manage-apne3/tgw && terraform output peering_attachment_id
  peering_attachment_id_from_apne3 = "tgw-attach-059477ad0dc15ab1b"
}

## ============================================================================
## TGW Peering Attachment Accepter - Accept request from ue1
## ============================================================================
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "from_use1" {
  count = local.peering_attachment_id != "" ? 1 : 0

  transit_gateway_attachment_id = local.peering_attachment_id

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-peering-from-use1"
    auto-delete = "no"
    Side        = "Accepter"
  }
}

## ============================================================================
## TGW Route Table Association - Peering
## NOTE: Skipped because default_route_table_association is enabled on TGW
## The peering attachment is automatically associated with the default route table
## ============================================================================
# resource "aws_ec2_transit_gateway_route_table_association" "peering_from_use1" {
#   count = local.peering_attachment_id != "" ? 1 : 0
#
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_use1[0].id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
#
#   depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.from_use1]
# }

## ============================================================================
## TGW Static Routes - Cross-region via peering
## IMPORTANT: Uncomment these AFTER peering is accepted
## ============================================================================

resource "aws_ec2_transit_gateway_route" "to_manage_use1" {
  destination_cidr_block         = local.manage_use1_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_use1[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1
  ]
}

resource "aws_ec2_transit_gateway_route" "to_dev_use1" {
  destination_cidr_block         = local.dev_use1_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_use1[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1
  ]
}

## ============================================================================
## VPC Routes - manage-apne2 to ue1 region
## IMPORTANT: Uncomment these AFTER peering is accepted
## ============================================================================

resource "aws_route" "manage_apne2_private_to_manage_use1" {
  for_each = toset(local.manage_apne2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_manage_use1
  ]
}

resource "aws_route" "manage_apne2_private_to_dev_use1" {
  for_each = toset(local.manage_apne2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_dev_use1
  ]
}

resource "aws_route" "manage_apne2_public_to_manage_use1" {
  for_each = toset(local.manage_apne2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_manage_use1
  ]
}

resource "aws_route" "manage_apne2_public_to_dev_use1" {
  for_each = toset(local.manage_apne2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.manage_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_dev_use1
  ]
}

## ============================================================================
## VPC Routes - dev-apne2 to ue1 region
## IMPORTANT: Uncomment these AFTER peering is accepted
## NOTE: dev-apne2 is Legacy (CLI managed), keeping cross-region routes in Terraform
## ============================================================================

resource "aws_route" "dev_apne2_private_to_manage_use1" {
  provider = aws.dev-apne2
  for_each = toset(local.dev_apne2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_manage_use1
  ]
}

resource "aws_route" "dev_apne2_private_to_dev_use1" {
  provider = aws.dev-apne2
  for_each = toset(local.dev_apne2.private_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_dev_use1
  ]
}

resource "aws_route" "dev_apne2_public_to_manage_use1" {
  provider = aws.dev-apne2
  for_each = toset(local.dev_apne2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.manage_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_manage_use1
  ]
}

resource "aws_route" "dev_apne2_public_to_dev_use1" {
  provider = aws.dev-apne2
  for_each = toset(local.dev_apne2.public_route_table_ids)

  route_table_id         = each.value
  destination_cidr_block = local.dev_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.dev_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_dev_use1
  ]
}

## ============================================================================
## TGW Peering Attachment Accepter - Accept request from ap3
## ============================================================================
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "from_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  transit_gateway_attachment_id = local.peering_attachment_id_from_apne3

  tags = {
    Name        = "${local.project_code}-${local.account}-${local.aws_region_code}-tgw-peering-from-apne3"
    auto-delete = "no"
    Side        = "Accepter"
  }
}

## ============================================================================
## TGW Static Routes - to ap3 region VPCs via peering
## ============================================================================
resource "aws_ec2_transit_gateway_route" "to_manage_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  destination_cidr_block         = local.manage_apne3_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_apne3[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.from_apne3]
}

resource "aws_ec2_transit_gateway_route" "to_dev_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  destination_cidr_block         = local.dev_apne3_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_apne3[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.from_apne3]
}

## ============================================================================
## VPC Routes - manage-apne2 to ap3 region
## ============================================================================
resource "aws_route" "manage_apne2_private_to_manage_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.manage_apne2.private_route_table_ids[0]
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "manage_apne2_private_to_dev_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.manage_apne2.private_route_table_ids[0]
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

resource "aws_route" "manage_apne2_public_to_manage_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.manage_apne2.public_route_table_ids[0]
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "manage_apne2_public_to_dev_apne3" {
  count = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.manage_apne2.public_route_table_ids[0]
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

## ============================================================================
## VPC Routes - dev-apne2 to ap3 region
## ============================================================================
resource "aws_route" "dev_apne2_private_to_manage_apne3" {
  provider = aws.dev-apne2
  count    = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.dev_apne2.private_route_table_ids[0]
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "dev_apne2_private_to_dev_apne3" {
  provider = aws.dev-apne2
  count    = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.dev_apne2.private_route_table_ids[0]
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

resource "aws_route" "dev_apne2_public_to_manage_apne3" {
  provider = aws.dev-apne2
  count    = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.dev_apne2.public_route_table_ids[0]
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "dev_apne2_public_to_dev_apne3" {
  provider = aws.dev-apne2
  count    = local.peering_attachment_id_from_apne3 != "" ? 1 : 0

  route_table_id         = local.dev_apne2.public_route_table_ids[0]
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

## ============================================================================
## VPC Routes - shared-apne2 to ap3 region
## ============================================================================
resource "aws_route" "shared_apne2_private_to_manage_apne3" {
  provider = aws.shared-apne2
  count    = local.peering_attachment_id_from_apne3 != "" && length(local.shared_apne2.private_route_table_ids) > 0 ? 1 : 0

  route_table_id         = local.shared_apne2.private_route_table_ids[0]
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "shared_apne2_private_to_dev_apne3" {
  provider = aws.shared-apne2
  count    = local.peering_attachment_id_from_apne3 != "" && length(local.shared_apne2.private_route_table_ids) > 0 ? 1 : 0

  route_table_id         = local.shared_apne2.private_route_table_ids[0]
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

resource "aws_route" "shared_apne2_public_to_manage_apne3" {
  provider = aws.shared-apne2
  count    = local.peering_attachment_id_from_apne3 != "" && length(local.shared_apne2.public_route_table_ids) > 0 ? 1 : 0

  route_table_id         = local.shared_apne2.public_route_table_ids[0]
  destination_cidr_block = local.manage_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_manage_apne3]
}

resource "aws_route" "shared_apne2_public_to_dev_apne3" {
  provider = aws.shared-apne2
  count    = local.peering_attachment_id_from_apne3 != "" && length(local.shared_apne2.public_route_table_ids) > 0 ? 1 : 0

  route_table_id         = local.shared_apne2.public_route_table_ids[0]
  destination_cidr_block = local.dev_apne3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_route.to_dev_apne3]
}

## ============================================================================
## Outputs
## ============================================================================
output "peering_accepter_status" {
  description = "TGW Peering Accepter Status"
  value       = local.peering_attachment_id != "" ? "Peering accepter from ue1 created" : "Not created yet - update peering_attachment_id first"
}

output "peering_accepter_apne3_status" {
  description = "TGW Peering Accepter from ap3 Status"
  value       = local.peering_attachment_id_from_apne3 != "" ? "Peering accepter from ap3 created" : "Not created yet - update peering_attachment_id_from_apne3 first"
}


## ============================================================================
## VPC Routes - shared-apne2 to ue1 region
## IMPORTANT: Uncomment these AFTER peering is accepted
## ============================================================================

resource "aws_route" "shared_apne2_private_to_manage_use1" {
  provider = aws.shared-apne2
  for_each = length(local.shared_apne2.private_route_table_ids) > 0 ? toset(local.shared_apne2.private_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = local.manage_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.shared_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_manage_use1
  ]
}

resource "aws_route" "shared_apne2_private_to_dev_use1" {
  provider = aws.shared-apne2
  for_each = length(local.shared_apne2.private_route_table_ids) > 0 ? toset(local.shared_apne2.private_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = local.dev_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.shared_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_dev_use1
  ]
}

resource "aws_route" "shared_apne2_public_to_manage_use1" {
  provider = aws.shared-apne2
  for_each = length(local.shared_apne2.public_route_table_ids) > 0 ? toset(local.shared_apne2.public_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = local.manage_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.shared_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_manage_use1
  ]
}

resource "aws_route" "shared_apne2_public_to_dev_use1" {
  provider = aws.shared-apne2
  for_each = length(local.shared_apne2.public_route_table_ids) > 0 ? toset(local.shared_apne2.public_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = local.dev_use1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.shared_apne2,
    aws_ec2_transit_gateway_peering_attachment_accepter.from_use1,
    aws_ec2_transit_gateway_route.to_dev_use1
  ]
}

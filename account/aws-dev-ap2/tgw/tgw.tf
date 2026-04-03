# =============================================================================
# dev-ap2 TGW Resources - Managed by manage-ap2/tgw
# =============================================================================
#
# All TGW resources for dev-ap2 are managed in:
#   account/aws-manage-ap2/tgw/tgw.tf
#   account/aws-manage-ap2/tgw/tgw-peering.tf
#
# Managed resources:
#   - VPC Attachment (dev-ap2 VPC → manage-ap2 TGW via RAM share)
#   - Same-region routes: dev-ap2 ↔ manage-ap2, dev-ap2 ↔ shared-ap2
#   - Cross-region routes: dev-ap2 → ue1, dev-ap2 → ap3
#
# Reason:
#   TGW is owned by manage account. Cross-account attachments and routes
#   are created using cross-account providers (aws.dev-ap2) in manage-ap2/tgw.
# =============================================================================

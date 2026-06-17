# =============================================================================
# dev-apne2 TGW Resources - Managed by manage-apne2/tgw
# =============================================================================
#
# All TGW resources for dev-apne2 are managed in:
#   account/aws-manage-apne2/tgw/tgw.tf
#   account/aws-manage-apne2/tgw/tgw-peering.tf
#
# Managed resources:
#   - VPC Attachment (dev-apne2 VPC → manage-apne2 TGW via RAM share)
#   - Same-region routes: dev-apne2 ↔ manage-apne2, dev-apne2 ↔ shared-apne2
#   - Cross-region routes: dev-apne2 → ue1, dev-apne2 → ap3
#
# Reason:
#   TGW is owned by manage account. Cross-account attachments and routes
#   are created using cross-account providers (aws.dev-apne2) in manage-apne2/tgw.
# =============================================================================

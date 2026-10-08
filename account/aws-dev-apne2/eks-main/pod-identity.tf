################################################################################
# EKS Pod Identity Associations (controllers deployed by ArgoCD)
################################################################################
resource "aws_eks_pod_identity_association" "this" {
  for_each = var.pod_identity_associations

  cluster_name    = aws_eks_cluster.main.name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = "arn:aws:iam::${local.account_id}:role/${each.value.role_name}"

  tags = var.common_tags
}

# Created out of band with the AWS CLI before being codified; remove after the first apply.
import {
  for_each = { for k, v in var.pod_identity_associations : k => v if v.import_id != null }

  to = aws_eks_pod_identity_association.this[each.key]
  id = "${var.eks_cluster_name},${each.value.import_id}"
}

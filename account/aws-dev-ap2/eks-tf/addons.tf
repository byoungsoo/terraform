################################################################################
# EKS Addons
################################################################################
resource "aws_eks_addon" "this" {
  for_each = var.eks_addons

  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = each.key
  addon_version               = each.value.addon_version
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  configuration_values        = each.value.configuration_values

  tags = var.common_tags
}

################################################################################
# Pod Identity Associations (conditional)
################################################################################
resource "aws_eks_pod_identity_association" "this" {
  for_each = {
    for k, v in var.eks_addons : k => v if v.pod_identity_role_name != null
  }

  cluster_name    = aws_eks_cluster.main.name
  namespace       = each.value.pod_identity_namespace
  service_account = each.value.pod_identity_service_account
  role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${each.value.pod_identity_role_name}"
}

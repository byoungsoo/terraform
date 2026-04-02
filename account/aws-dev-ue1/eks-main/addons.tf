################################################################################
# EKS Addons
################################################################################

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_addon_version
  resolve_conflicts_on_update = var.vpc_cni_resolve_conflicts_on_update

  tags = var.common_tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_addon_version
  resolve_conflicts_on_update = var.kube_proxy_resolve_conflicts_on_update

  tags = var.common_tags
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_addon_version
  resolve_conflicts_on_update = var.coredns_resolve_conflicts_on_update

  configuration_values = var.coredns_configuration_values != null ? jsonencode(var.coredns_configuration_values) : null

  tags = var.common_tags
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.pod_identity_agent_addon_version
  resolve_conflicts_on_update = var.pod_identity_agent_resolve_conflicts_on_update

  tags = var.common_tags
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.ebs_csi_driver_addon_version
  resolve_conflicts_on_update = var.ebs_csi_driver_resolve_conflicts_on_update

  tags = var.common_tags
}

## Pod Identity Associations
resource "aws_eks_pod_identity_association" "ebs_csi_driver_identity" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = var.ebs_csi_driver_role_arn
}

resource "aws_eks_pod_identity_association" "aws_lbc_identity" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = var.aws_lbc_role_arn
}

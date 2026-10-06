################################################################################
# Data Sources
################################################################################
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

################################################################################
# EKS Cluster
################################################################################
resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = "arn:aws:iam::${local.account_id}:role/${var.eks_cluster_role_name}"
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.eks_public_access_cidrs
  }

  depends_on = [aws_cloudwatch_log_group.eks_main_log_group]
  enabled_cluster_log_types = var.eks_log_types

  access_config {
    authentication_mode = "API"
  }

  tags = merge(var.common_tags, {
    Name = var.eks_cluster_name
  })
}

resource "aws_cloudwatch_log_group" "eks_main_log_group" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.eks_log_retention_in_days
}

################################################################################
# OIDC Provider
################################################################################
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = var.common_tags
}

################################################################################
# EKS Node Group
################################################################################
resource "aws_eks_node_group" "ng_al2023_x86_c5large" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.ng_al2023_x86_c5large_name
  node_role_arn   = "arn:aws:iam::${local.account_id}:role/${var.ng_al2023_x86_c5large_role_name}"
  subnet_ids      = var.private_subnet_ids

  ami_type       = var.ng_al2023_x86_c5large_ami_type
  instance_types = var.ng_al2023_x86_c5large_instance_types

  scaling_config {
    desired_size = var.ng_al2023_x86_c5large_desired_size
    max_size     = var.ng_al2023_x86_c5large_max_size
    min_size     = var.ng_al2023_x86_c5large_min_size
  }

  tags = var.common_tags
}

################################################################################
# Access Entries
################################################################################
resource "aws_eks_access_entry" "karpenter_node_role" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = "arn:aws:iam::${local.account_id}:role/${var.karpenter_node_role_name}"
  type          = "EC2_LINUX"

  tags = var.common_tags
}

resource "aws_eks_access_entry" "admin_role" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = "arn:aws:iam::${local.account_id}:role/${var.access_entry_admin_role_name}"
  type          = "STANDARD"

  tags = var.common_tags
}

resource "aws_eks_access_policy_association" "admin_role" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.admin_role.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "admin_user" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = "arn:aws:iam::${local.account_id}:user/${var.access_entry_admin_user_name}"
  type          = "STANDARD"

  tags = var.common_tags
}

resource "aws_eks_access_policy_association" "admin_user" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.admin_user.principal_arn

  access_scope {
    type = "cluster"
  }
}

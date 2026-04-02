################################################################################
# EKS Cluster Outputs
################################################################################
output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = aws_eks_cluster.main.version
}

################################################################################
# OIDC Provider Outputs
################################################################################
output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

################################################################################
# Node Group Outputs
################################################################################
output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.ng_al2023_x86_c5large.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.ng_al2023_x86_c5large.status
}

################################################################################
# EKS Addons Outputs
################################################################################
output "eks_addons" {
  description = "Map of EKS addons and their status"
  value = {
    vpc_cni = {
      arn     = aws_eks_addon.vpc_cni.arn
      status  = aws_eks_addon.vpc_cni.status
      version = aws_eks_addon.vpc_cni.addon_version
    }
    kube_proxy = {
      arn     = aws_eks_addon.kube_proxy.arn
      status  = aws_eks_addon.kube_proxy.status
      version = aws_eks_addon.kube_proxy.addon_version
    }
    coredns = {
      arn     = aws_eks_addon.coredns.arn
      status  = aws_eks_addon.coredns.status
      version = aws_eks_addon.coredns.addon_version
    }
    pod_identity_agent = {
      arn     = aws_eks_addon.pod_identity_agent.arn
      status  = aws_eks_addon.pod_identity_agent.status
      version = aws_eks_addon.pod_identity_agent.addon_version
    }
    ebs_csi_driver = {
      arn     = aws_eks_addon.ebs_csi_driver.arn
      status  = aws_eks_addon.ebs_csi_driver.status
      version = aws_eks_addon.ebs_csi_driver.addon_version
    }
  }
}

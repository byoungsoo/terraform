################################################################################
# Project Configuration
################################################################################
variable "project_code" {
  type        = string
  description = "Project code for resource naming"
}

variable "account" {
  type        = string
  description = "Account environment (dev, staging, prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_region_code" {
  type        = string
  description = "AWS region code (e.g., ap2, ue1)"
}

################################################################################
# Common Tags
################################################################################
variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default     = {}
}

################################################################################
# Existing Resources (Sensitive)
################################################################################
variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster will be deployed"
  sensitive   = true
}

variable "private_app3_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS cluster"
  sensitive   = true
}

variable "eks_cluster_iam_role_arn" {
  type        = string
  description = "IAM role ARN for EKS cluster"
  sensitive   = true
}

variable "karpenter_node_role_arn" {
  type        = string
  description = "Karpenter node IAM role ARN"
  sensitive   = true
}

################################################################################
# EKS Cluster Configuration
################################################################################
variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_cluster_version" {
  type        = string
  description = "EKS cluster version"
  
  validation {
    condition     = can(regex("^\\d+\\.\\d+$", var.eks_cluster_version))
    error_message = "EKS cluster version must be in format X.Y (e.g., 1.33)"
  }
}

variable "eks_log_types" {
  type        = list(string)
  description = "EKS cluster log types to enable"
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

################################################################################
# EKS Node Group Configuration
################################################################################
variable "ng_al2023_x86_c5large_iam_role_arn" {
  type        = string
  description = "IAM role ARN for EKS managed node group"
  sensitive   = true
}

variable "ng_al2023_x86_c5large_name" {
  type        = string
  description = "EKS managed node group name"
}

variable "ng_al2023_x86_c5large_instance_types" {
  type        = list(string)
  description = "Instance types for EKS managed node group"
}

variable "ng_al2023_x86_c5large_ami_type" {
  type        = string
  description = "AMI type for EKS managed node group"
  default     = "AL2023_x86_64_STANDARD"
}

################################################################################
# Access Entries (Sensitive)
################################################################################
variable "access_entry_admin_role" {
  type        = string
  description = "Admin role ARN for EKS cluster access"
  sensitive   = true
}

variable "access_entry_admin_user" {
  type        = string
  description = "Admin user ARN for EKS cluster access"
  sensitive   = true
}

################################################################################
# EKS Addons Configuration
################################################################################
variable "vpc_cni_addon_version" {
  type        = string
  description = "VPC CNI addon version"
}

variable "vpc_cni_resolve_conflicts_on_update" {
  type        = string
  description = "How to resolve conflicts on VPC CNI addon update"
  default     = "OVERWRITE"
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "Kube-proxy addon version"
}

variable "kube_proxy_resolve_conflicts_on_update" {
  type        = string
  description = "How to resolve conflicts on kube-proxy addon update"
  default     = "OVERWRITE"
}

variable "coredns_addon_version" {
  type        = string
  description = "CoreDNS addon version"
}

variable "coredns_resolve_conflicts_on_update" {
  type        = string
  description = "How to resolve conflicts on CoreDNS addon update"
  default     = "OVERWRITE"
}

variable "pod_identity_agent_addon_version" {
  type        = string
  description = "Pod Identity Agent addon version"
}

variable "pod_identity_agent_resolve_conflicts_on_update" {
  type        = string
  description = "How to resolve conflicts on Pod Identity Agent addon update"
  default     = "OVERWRITE"
}

variable "ebs_csi_driver_addon_version" {
  type        = string
  description = "EBS CSI Driver addon version"
}

variable "ebs_csi_driver_resolve_conflicts_on_update" {
  type        = string
  description = "How to resolve conflicts on EBS CSI Driver addon update"
  default     = "OVERWRITE"
}

variable "ebs_csi_driver_role_arn" {
  type        = string
  description = "EBS CSI Driver IAM role ARN"
  sensitive   = true
}

variable "aws_lbc_role_arn" {
  type        = string
  description = "AWS Load Balancer Controller IAM role ARN"
  sensitive   = true
}

variable "coredns_configuration_values" {
  type = object({
    autoScaling = object({
      enabled     = bool
      minReplicas = number
      maxReplicas = number
    })
    affinity = object({
      nodeAffinity = object({
        requiredDuringSchedulingIgnoredDuringExecution = object({
          nodeSelectorTerms = list(object({
            matchExpressions = list(object({
              key      = string
              operator = string
            }))
          }))
        })
      })
      podAntiAffinity = object({
        preferredDuringSchedulingIgnoredDuringExecution = list(object({
          podAffinityTerm = object({
            labelSelector = object({
              matchExpressions = list(object({
                key      = string
                operator = string
                values   = list(string)
              }))
            })
            topologyKey = string
          })
          weight = number
        }))
      })
    })
  })
  description = "CoreDNS addon configuration values"
  default     = null
}

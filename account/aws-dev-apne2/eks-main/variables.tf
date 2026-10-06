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
# Network
################################################################################
variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS cluster"
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
    error_message = "EKS cluster version must be in format X.Y (e.g., 1.35)"
  }
}

variable "eks_cluster_role_name" {
  type        = string
  description = "IAM role name for EKS cluster"
}

variable "eks_public_access_cidrs" {
  type        = list(string)
  description = "CIDR blocks for EKS public endpoint access"
  default     = ["0.0.0.0/0"]
}

variable "eks_log_types" {
  type        = list(string)
  description = "EKS cluster log types to enable"
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_log_retention_in_days" {
  type        = number
  description = "CloudWatch log group retention in days"
  default     = 545
}

################################################################################
# EKS Node Group Configuration
################################################################################
variable "ng_al2023_x86_c5large_role_name" {
  type        = string
  description = "IAM role name for EKS managed node group"
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

variable "ng_al2023_x86_c5large_desired_size" {
  type        = number
  description = "Desired number of nodes"
  default     = 1
}

variable "ng_al2023_x86_c5large_max_size" {
  type        = number
  description = "Maximum number of nodes"
  default     = 1
}

variable "ng_al2023_x86_c5large_min_size" {
  type        = number
  description = "Minimum number of nodes"
  default     = 1
}

################################################################################
# Access Entries
################################################################################
variable "karpenter_node_role_name" {
  type        = string
  description = "Karpenter node IAM role name"
}

variable "access_entry_admin_role_name" {
  type        = string
  description = "Admin role name for EKS cluster access"
}

variable "access_entry_admin_user_name" {
  type        = string
  description = "Admin user name for EKS cluster access"
}

################################################################################
# EKS Addons Configuration
################################################################################
variable "eks_addons" {
  type = map(object({
    addon_version                = string
    resolve_conflicts_on_update  = optional(string, "OVERWRITE")
    configuration_values         = optional(string)
    pod_identity_role_name       = optional(string)
    pod_identity_namespace       = optional(string, "kube-system")
    pod_identity_service_account = optional(string)
  }))
  description = "Map of EKS addons to install. Key is addon name."
  default     = {}
}

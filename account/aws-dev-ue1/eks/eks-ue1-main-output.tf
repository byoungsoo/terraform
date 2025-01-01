################################################################################
# Cluster
################################################################################
output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = try(module.eks.arn, null)
}

output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = try(module.eks.cluster_id, "")
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = try(module.eks.name, "")
}

################################################################################
# EKS Auto Node IAM Role
################################################################################




################################################################################
# Access Entry
################################################################################

output "access_entries" {
  description = "Map of access entries created and their attributes"
  value       = module.eks.access_entries
}
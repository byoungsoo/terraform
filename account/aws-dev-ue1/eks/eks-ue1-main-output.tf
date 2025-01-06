################################################################################
# Cluster
################################################################################
output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = try(module.eks.cluster_arn, null)
}
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = try(module.eks.cluster_name, "")
}

output "cluster_security_group_id" {
  description = "The ID of cluster_security_group_id"
  value       = try(module.eks.cluster_security_group_id, "")
}


################################################################################
# EKS Auto Node IAM Role
################################################################################




################################################################################
# EKS MNG
################################################################################
output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups
}

output "node_group_autoscaling_group_names" {
  value = module.eks.eks_managed_node_groups_autoscaling_group_names
}



################################################################################
# Access Entry
################################################################################
output "access_entries" {
  description = "Map of access entries created and their attributes"
  value       = module.eks.access_entries
}

output "cluster_addons" {
  description = "Map of access entries created and their attributes"
  value       = module.eks.cluster_addons
}


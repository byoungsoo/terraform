################################################################################
# VPC
################################################################################
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_main.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc_main.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc_main.cidr_block
}

################################################################################
# Subnets
################################################################################
output "public_subnet_objects" {
  description = "A map of all public subnets, containing the full objects."
  value       = aws_subnet.public_subnets
}

output "public_subnet_name" {
  description = "A list of all public subnet names."
  value       = [for subnet in aws_subnet.public_subnets : subnet.tags.Name]
}

output "private_subnet_objects" {
  description = "A map of all private subnets, containing the full objects."
  value       = aws_subnet.private_subnets
}

output "private_subnet_name" {
  description = "A list of all private subnet names."
  value       = [for subnet in aws_subnet.private_subnets : subnet.tags.Name]
}

output "nat_subnet_azs" {
  description = "A list of all nat subnet azs."
  value       = local.nat_subnet_azs
}

output "public_subnet_ids" {
  description = "A list of all public subnet ids."
  value       = local.public_subnet_ids
}

output "private_subnet_ids" {
  description = "A list of all private subnet ids."
  value       = local.private_subnet_ids
}

output "prvonly_subnet_objects" {
  description = "A map of all prvonly subnets, containing the full objects."
  value       = aws_subnet.prvonly_subnets
}

output "prvonly_subnet_name" {
  description = "A list of all prvonly subnet names."
  value       = [for subnet in aws_subnet.prvonly_subnets : subnet.tags.Name]
}

output "prvonly_subnet_ids" {
  description = "A list of all prvonly subnet ids."
  value       = local.prvonly_subnet_ids
}

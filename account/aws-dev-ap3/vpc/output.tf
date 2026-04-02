
################################################################################
# VPC
################################################################################
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr" {
  description = "The CIDR of the VPC"
  value       = module.vpc.vpc_cidr_block
}


################################################################################
# Publiс Subnets
################################################################################
# output "public_subnet_objects" {
#   description = "A list of all public subnets, containing the full objects."
#   value       = module.vpc.public_subnet_objects
# }

# output "private_subnet_objects" {
#   description = "A list of all public subnets, containing the full objects."
#   value       = module.vpc.private_subnet_objects
# }


output "public_subnet_name" {
  description = "A list of all public subnets, containing the full objects."
  value       = module.vpc.public_subnet_name
}

output "private_subnet_name" {
  description = "A list of all public subnets, containing the full objects."
  value       = module.vpc.private_subnet_name
}

output "nat_subnet_azs"{
  description = "A list of all nat subnet azs."
  value = module.vpc.nat_subnet_azs
}

output "public_subnet_ids"{
  description = "A list of all public subnets ids."
  value = module.vpc.public_subnet_ids
}
output "private_subnet_ids"{
  description = "A list of all private subnets ids."
  value = module.vpc.private_subnet_ids
}

output "prvonly_subnet_ids"{
  description = "A list of all prvonly subnets ids."
  value = module.vpc.prvonly_subnet_ids
}

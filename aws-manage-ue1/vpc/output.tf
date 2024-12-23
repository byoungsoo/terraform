# Output of VPC, Subnet
output "vpc_id" {
    value = aws_vpc.bys_vpc_main.id
}

output "vpc_cidr_block" {
    value = aws_vpc.bys_vpc_main.cidr_block
}
# Output of Pub subnet
output "pub_subnet_ids" {
    value = { for prv_subnet_id, subnet in aws_subnet.bys_pub_subnets : prv_subnet_id => subnet.id }
}

output "prv_subnet_ids" {
  value = { for prv_subnet_id, subnet in aws_subnet.bys_prv_subnets : prv_subnet_id => subnet.id }
}

output "prv_only_subnet_ids" {
  value = { for prv_only_subnet_id, subnet in aws_subnet.bys_prv_only_subnets : prv_only_subnet_id => subnet.id }
}

################################################################################
# All tags
################################################################################
all_tags={
  auto-delete="no"
}

################################################################################
# VPC
################################################################################
vpc_cidr = "10.3.0.0/16"
secondary_cidr_blocks = ["100.64.0.0/16"]

################################################################################
# Subnets
################################################################################
public_subnet_cidr_blocks = [
    {name="dmz", cidr_block="10.3.1.0/24", az="ap-northeast-3a"},
    {name="dmz", cidr_block="10.3.2.0/24", az="ap-northeast-3b"},
    {name="dmz", cidr_block="10.3.3.0/24", az="ap-northeast-3c"},
    
    
    {name="extelb", cidr_block="10.3.11.0/24", az="ap-northeast-3a"},
    {name="extelb", cidr_block="10.3.12.0/24", az="ap-northeast-3b"},
    {name="extelb", cidr_block="10.3.13.0/24", az="ap-northeast-3c"}
]

private_subnet_cidr_blocks = [
    {name="app", cidr_block="10.3.24.0/21", az="ap-northeast-3a"},
    {name="app", cidr_block="10.3.32.0/21", az="ap-northeast-3b"},
    {name="app", cidr_block="10.3.40.0/21", az="ap-northeast-3c"},
    
    {name="intelb", cidr_block="10.3.81.0/24", az="ap-northeast-3a"},
    {name="intelb", cidr_block="10.3.82.0/24", az="ap-northeast-3b"},
    {name="intelb", cidr_block="10.3.83.0/24", az="ap-northeast-3c"},
    
    {name="db", cidr_block="10.3.91.0/24", az="ap-northeast-3a"},
    {name="db", cidr_block="10.3.92.0/24", az="ap-northeast-3b"},
    {name="db", cidr_block="10.3.93.0/24", az="ap-northeast-3c"}
]

prvonly_subnet_cidr_blocks = [
    {name="prvonly", cidr_block="10.3.101.0/24", az="ap-northeast-3a"},
    {name="prvonly", cidr_block="10.3.102.0/24", az="ap-northeast-3b"},
    {name="prvonly", cidr_block="10.3.103.0/24", az="ap-northeast-3c"}
]

karpenter_subnet_name = "app"
karpenter_tag = {
  "subnet" = "karpenter"
}
nat_gateway_subnet_name = "dmz"
################################################################################
# Gateway
################################################################################
create_igw = true
igw_name = "main"
enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = true
nat_gateway_destination_cidr_block = "0.0.0.0/0"
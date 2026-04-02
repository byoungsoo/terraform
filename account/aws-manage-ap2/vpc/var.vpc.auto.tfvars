################################################################################
# All tags
################################################################################
all_tags={
  auto-delete="no"
}

################################################################################
# VPC
################################################################################
vpc_cidr = "10.0.0.0/16"
secondary_cidr_blocks = ["100.64.0.0/16"]

################################################################################
# Subnets
################################################################################
public_subnet_cidr_blocks = [
    {name="dmz", cidr_block="10.0.1.0/24", az="ap-northeast-2a"},
    {name="dmz", cidr_block="10.0.2.0/24", az="ap-northeast-2b"},
    {name="dmz", cidr_block="10.0.3.0/24", az="ap-northeast-2c"},
    {name="dmz", cidr_block="10.0.4.0/24", az="ap-northeast-2d"},
    
    {name="extelb", cidr_block="10.0.11.0/24", az="ap-northeast-2a"},
    {name="extelb", cidr_block="10.0.12.0/24", az="ap-northeast-2b"},
    {name="extelb", cidr_block="10.0.13.0/24", az="ap-northeast-2c"},
    {name="extelb", cidr_block="10.0.14.0/24", az="ap-northeast-2d"},
]

private_subnet_cidr_blocks = [
    {name="app", cidr_block="10.0.24.0/21", az="ap-northeast-2a"},
    {name="app", cidr_block="10.0.32.0/21", az="ap-northeast-2b"},
    {name="app", cidr_block="10.0.40.0/21", az="ap-northeast-2c"},
    {name="app", cidr_block="10.0.48.0/21", az="ap-northeast-2d"},
    
    {name="intelb", cidr_block="10.0.81.0/24", az="ap-northeast-2a"},
    {name="intelb", cidr_block="10.0.82.0/24", az="ap-northeast-2b"},
    {name="intelb", cidr_block="10.0.83.0/24", az="ap-northeast-2c"},
    {name="intelb", cidr_block="10.0.84.0/24", az="ap-northeast-2d"},
    
    {name="db", cidr_block="10.0.91.0/24", az="ap-northeast-2a"},
    {name="db", cidr_block="10.0.92.0/24", az="ap-northeast-2b"},
    {name="db", cidr_block="10.0.93.0/24", az="ap-northeast-2c"},
    {name="db", cidr_block="10.0.94.0/24", az="ap-northeast-2d"},
]

prvonly_subnet_cidr_blocks = [
    {name="prvonly", cidr_block="10.0.101.0/24", az="ap-northeast-2a"},
    {name="prvonly", cidr_block="10.0.102.0/24", az="ap-northeast-2b"},
    {name="prvonly", cidr_block="10.0.103.0/24", az="ap-northeast-2c"},
    {name="prvonly", cidr_block="10.0.104.0/24", az="ap-northeast-2d"}
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

################################################################################
# All tags
################################################################################
all_tags={
  auto-delete="no"
}

################################################################################
# VPC
################################################################################
vpc_cidr = "10.30.0.0/16"
secondary_cidr_blocks = ["100.64.0.0/16"]

################################################################################
# Subnets
################################################################################
public_subnet_cidr_blocks = [
    {name="dmz", cidr_block="10.30.1.0/24", az="ap-northeast-3a"},
    {name="dmz", cidr_block="10.30.2.0/24", az="ap-northeast-3b"},
    {name="dmz", cidr_block="10.30.3.0/24", az="ap-northeast-3c"},
    
    {name="extelb", cidr_block="10.30.11.0/24", az="ap-northeast-3a"},
    {name="extelb", cidr_block="10.30.12.0/24", az="ap-northeast-3b"},
    {name="extelb", cidr_block="10.30.13.0/24", az="ap-northeast-3c"}
]

private_subnet_cidr_blocks = [
    {name="app", cidr_block="10.30.24.0/21", az="ap-northeast-3a"},
    {name="app", cidr_block="10.30.32.0/21", az="ap-northeast-3b"},
    {name="app", cidr_block="10.30.40.0/21", az="ap-northeast-3c"},
    
    {name="intelb", cidr_block="10.30.81.0/24", az="ap-northeast-3a"},
    {name="intelb", cidr_block="10.30.82.0/24", az="ap-northeast-3b"},
    {name="intelb", cidr_block="10.30.83.0/24", az="ap-northeast-3c"},
    
    {name="db", cidr_block="10.30.91.0/24", az="ap-northeast-3a"},
    {name="db", cidr_block="10.30.92.0/24", az="ap-northeast-3b"},
    {name="db", cidr_block="10.30.93.0/24", az="ap-northeast-3c"},

    {name="secondary", cidr_block="100.64.0.0/20", az="ap-northeast-3a"},
    {name="secondary", cidr_block="100.64.16.0/20", az="ap-northeast-3b"},
    {name="secondary", cidr_block="100.64.32.0/20", az="ap-northeast-3c"}
]

prvonly_subnet_cidr_blocks = [
    {name="prvonly", cidr_block="10.30.101.0/24", az="ap-northeast-3a"},
    {name="prvonly", cidr_block="10.30.102.0/24", az="ap-northeast-3b"},
    {name="prvonly", cidr_block="10.30.103.0/24", az="ap-northeast-3c"}
]

karpenter_subnet_name = "app"
karpenter_tag = {
  "subnet" = "karpenter"
}
intelb_subnet_name = "intelb"
intelb_tag = {
  "kubernetes.io/role/internal-elb" = "1"
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
################################################################################
# All tags
################################################################################
all_tags={
  auto-delete="no"
}

################################################################################
# VPC
################################################################################
vpc_cidr = "10.5.0.0/16"
secondary_cidr_blocks = ["100.64.0.0/16"]

################################################################################
# Subnets
################################################################################
public_subnet_cidr_blocks = [
    {name="dmz", cidr_block="10.5.1.0/24", az="us-east-1a"},
    {name="dmz", cidr_block="10.5.2.0/24", az="us-east-1b"},
    {name="dmz", cidr_block="10.5.3.0/24", az="us-east-1c"},
    {name="dmz", cidr_block="10.5.4.0/24", az="us-east-1d"},
    {name="dmz", cidr_block="10.5.5.0/24", az="us-east-1e"},
    {name="dmz", cidr_block="10.5.6.0/24", az="us-east-1f"},
    
    {name="extelb", cidr_block="10.5.11.0/24", az="us-east-1a"},
    {name="extelb", cidr_block="10.5.12.0/24", az="us-east-1b"},
    {name="extelb", cidr_block="10.5.13.0/24", az="us-east-1c"},
    {name="extelb", cidr_block="10.5.14.0/24", az="us-east-1d"},
    {name="extelb", cidr_block="10.5.15.0/24", az="us-east-1e"},
    {name="extelb", cidr_block="10.5.16.0/24", az="us-east-1f"},
]

private_subnet_cidr_blocks = [
    {name="app", cidr_block="10.5.24.0/21", az="us-east-1a"},
    {name="app", cidr_block="10.5.32.0/21", az="us-east-1b"},
    {name="app", cidr_block="10.5.40.0/21", az="us-east-1c"},
    {name="app", cidr_block="10.5.48.0/21", az="us-east-1d"},
    {name="app", cidr_block="10.5.56.0/21", az="us-east-1e"},
    {name="app", cidr_block="10.5.64.0/21", az="us-east-1f"},
    
    {name="intelb", cidr_block="10.5.81.0/24", az="us-east-1a"},
    {name="intelb", cidr_block="10.5.82.0/24", az="us-east-1b"},
    {name="intelb", cidr_block="10.5.83.0/24", az="us-east-1c"},
    {name="intelb", cidr_block="10.5.84.0/24", az="us-east-1d"},
    {name="intelb", cidr_block="10.5.85.0/24", az="us-east-1e"},
    {name="intelb", cidr_block="10.5.86.0/24", az="us-east-1f"},
    
    {name="db", cidr_block="10.5.91.0/24", az="us-east-1a"},
    {name="db", cidr_block="10.5.92.0/24", az="us-east-1b"},
    {name="db", cidr_block="10.5.93.0/24", az="us-east-1c"},
    {name="db", cidr_block="10.5.94.0/24", az="us-east-1d"},
    {name="db", cidr_block="10.5.95.0/24", az="us-east-1e"},
    {name="db", cidr_block="10.5.96.0/24", az="us-east-1f"},
]

prvonly_subnet_cidr_blocks = [
    {name="prvonly", cidr_block="10.5.101.0/24", az="us-east-1a"},
    {name="prvonly", cidr_block="10.5.102.0/24", az="us-east-1b"},
    {name="prvonly", cidr_block="10.5.103.0/24", az="us-east-1c"},
    {name="prvonly", cidr_block="10.5.104.0/24", az="us-east-1d"},
    {name="prvonly", cidr_block="10.5.105.0/24", az="us-east-1e"},
    {name="prvonly", cidr_block="10.5.106.0/24", az="us-east-1f"}
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
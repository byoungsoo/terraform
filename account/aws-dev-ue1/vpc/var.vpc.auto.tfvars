################################################################################
# All tags
################################################################################
all_tags={
  auto-delete="no"
}

################################################################################
# VPC
################################################################################
vpc_cidr = "10.25.0.0/16"
secondary_cidr_blocks = ["100.64.0.0/16"]

################################################################################
# Subnets
################################################################################
public_subnet_cidr_blocks = [
    {name="dmz", cidr_block="10.25.1.0/24", az="us-east-1a"},
    {name="dmz", cidr_block="10.25.2.0/24", az="us-east-1b"},
    {name="dmz", cidr_block="10.25.3.0/24", az="us-east-1c"},
    {name="dmz", cidr_block="10.25.4.0/24", az="us-east-1d"},
    {name="dmz", cidr_block="10.25.5.0/24", az="us-east-1e"},
    {name="dmz", cidr_block="10.25.6.0/24", az="us-east-1f"},
    
    {name="extelb", cidr_block="10.25.11.0/24", az="us-east-1a"},
    {name="extelb", cidr_block="10.25.12.0/24", az="us-east-1b"},
    {name="extelb", cidr_block="10.25.13.0/24", az="us-east-1c"},
    {name="extelb", cidr_block="10.25.14.0/24", az="us-east-1d"},
    {name="extelb", cidr_block="10.25.15.0/24", az="us-east-1e"},
    {name="extelb", cidr_block="10.25.16.0/24", az="us-east-1f"},
]

private_subnet_cidr_blocks = [
    {name="app", cidr_block="10.25.24.0/21", az="us-east-1a"},
    {name="app", cidr_block="10.25.32.0/21", az="us-east-1b"},
    {name="app", cidr_block="10.25.40.0/21", az="us-east-1c"},
    {name="app", cidr_block="10.25.48.0/21", az="us-east-1d"},
    {name="app", cidr_block="10.25.56.0/21", az="us-east-1e"},
    {name="app", cidr_block="10.25.64.0/21", az="us-east-1f"},
    
    {name="intelb", cidr_block="10.25.81.0/24", az="us-east-1a"},
    {name="intelb", cidr_block="10.25.82.0/24", az="us-east-1b"},
    {name="intelb", cidr_block="10.25.83.0/24", az="us-east-1c"},
    {name="intelb", cidr_block="10.25.84.0/24", az="us-east-1d"},
    {name="intelb", cidr_block="10.25.85.0/24", az="us-east-1e"},
    {name="intelb", cidr_block="10.25.86.0/24", az="us-east-1f"},
    
    {name="db", cidr_block="10.25.91.0/24", az="us-east-1a"},
    {name="db", cidr_block="10.25.92.0/24", az="us-east-1b"},
    {name="db", cidr_block="10.25.93.0/24", az="us-east-1c"},
    {name="db", cidr_block="10.25.94.0/24", az="us-east-1d"},
    {name="db", cidr_block="10.25.95.0/24", az="us-east-1e"},
    {name="db", cidr_block="10.25.96.0/24", az="us-east-1f"},

    {name="secondary", cidr_block="100.64.0.0/20", az="us-east-1a"},
    {name="secondary", cidr_block="100.64.16.0/20", az="us-east-1b"},
    {name="secondary", cidr_block="100.64.32.0/20", az="us-east-1c"},
    {name="secondary", cidr_block="100.64.48.0/20", az="us-east-1d"},
    {name="secondary", cidr_block="100.64.64.0/20", az="us-east-1e"},
    {name="secondary", cidr_block="100.64.80.0/20", az="us-east-1f"},
]

prvonly_subnet_cidr_blocks = [
    {name="prvonly", cidr_block="10.25.101.0/24", az="us-east-1a"},
    {name="prvonly", cidr_block="10.25.102.0/24", az="us-east-1b"},
    {name="prvonly", cidr_block="10.25.103.0/24", az="us-east-1c"},
    {name="prvonly", cidr_block="10.25.104.0/24", az="us-east-1d"},
    {name="prvonly", cidr_block="10.25.105.0/24", az="us-east-1e"},
    {name="prvonly", cidr_block="10.25.106.0/24", az="us-east-1f"}
]

################################################################################
# Gateway
################################################################################
create_igw = true
igw_name = "main"
enable_nat_gateway = true
nat_gateway_subnet_name = "dmz"
single_nat_gateway = true
one_nat_gateway_per_az = true
nat_gateway_destination_cidr_block = "0.0.0.0/0"
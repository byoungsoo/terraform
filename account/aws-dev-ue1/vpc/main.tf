# Resource Naming Rule
#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

module "vpc" {
  # source = "git::https://github.com/byoungsoo/module-vpc.git"
  source = "../../../module/module-vpc"

  common_resource_name = "${var.project_code}-${var.account}-${var.aws_region_code}"
  all_tags = var.all_tags

  vpc_name = "main"
  vpc_cidr = var.vpc_cidr
  secondary_cidr_blocks = var.secondary_cidr_blocks

  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  prvonly_subnet_cidr_blocks = var.prvonly_subnet_cidr_blocks
  
  create_igw = var.create_igw
  igw_name = var.igw_name

  enable_nat_gateway = var.enable_nat_gateway
  nat_gateway_subnet_name = var.nat_gateway_subnet_name
  single_nat_gateway = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  nat_gateway_destination_cidr_block = var.nat_gateway_destination_cidr_block
}


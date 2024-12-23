#Naming Rule
#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

// vpc
resource "aws_vpc" "bys_vpc_main" { 
  cidr_block  = var.vpc_cidr_blocks["primary_cidr_block"]
  instance_tenancy = "default" 
  enable_dns_support                = true 
  enable_dns_hostnames              = true 
  assign_generated_ipv6_cidr_block  = false 
  tags = { 
          Name = "${var.project_code}-${var.account}-${var.aws_region_code}-vpc" 
        }
}

resource "aws_subnet" "bys_pub_subnets" {
  for_each                  = { for pub_sub, list in var.pub_subnet_cidr_blocks : pub_sub => list }
  vpc_id                    = aws_vpc.bys_vpc_main.id
  map_public_ip_on_launch   = true
  cidr_block                = each.value[1]
  availability_zone         = each.value[2]
  tags = { 
          Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-${split("-",each.value[0])[2]}-${split("-",each.value[0])[1]}"
        }
}

resource "aws_subnet" "bys_prv_subnets" {
  for_each                  = { for prv_sub, list in var.prv_subnet_cidr_blocks : prv_sub => list }
  vpc_id                    = aws_vpc.bys_vpc_main.id
  cidr_block                = each.value[1]
  availability_zone         = each.value[2]
  tags = { 
          Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-${split("-",each.value[0])[2]}-${split("-",each.value[0])[1]}"
        }
}

resource "aws_subnet" "bys_prv_only_subnets" {
  for_each                  = { for prv_sub, list in var.prv_only_subnet_cidr_blocks : prv_sub => list }
  vpc_id                    = aws_vpc.bys_vpc_main.id
  cidr_block                = each.value[1]
  availability_zone         = each.value[2]
  tags = { 
          Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-${split("-",each.value[0])[2]}-${split("-",each.value[0])[1]}"
        }
}
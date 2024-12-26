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


resource "aws_subnet" "bys_subnets" {
  for_each                  = { for subnet in var.subnet_cidr_blocks : subnet.name => subnet } 
  #   "sbn-dmz-az1" => ["sbn-dmz-az1", "10.120.1.0/24", "us-east-1a", "public"]

  vpc_id                    = aws_vpc.bys_vpc_main.id
  cidr_block                = each.value.cidr_block
  availability_zone         = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false
  tags = { 
          Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-${split("-",each.value.name)[2]}-${split("-",each.value.name)[1]}"
        }
}


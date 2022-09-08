#Naming Rule
#ProjectCode-Account-Resource-{att1}-{zone}

// vpc
resource "aws_vpc" "bys_vpc" { 
  cidr_block  = var.cidr_blocks["vpc"]
  instance_tenancy = "default" 
  enable_dns_support                = true 
  enable_dns_hostnames              = true 
  assign_generated_ipv6_cidr_block  = false 

  tags = { 
          "Name" = "${var.project_code}-${var.account}-vpc" 
        }
}

// public subnets
resource "aws_subnet" "bys_sbn_az1_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az1_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az1-dmz"
  }
}

resource "aws_subnet" "bys_sbn_az2_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az2_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az2-dmz"
  }
}

resource "aws_subnet" "bys_sbn_az1_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az1_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az1-extelb"
  }
}

resource "aws_subnet" "bys_sbn_az2_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az2_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az2-extelb"
  }
}

// private subnets
resource "aws_subnet" "bys_sbn_az1_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az1_app"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az1-app"
  }
}

resource "aws_subnet" "bys_sbn_az2_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az2_app"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az2-app"
  }
}

resource "aws_subnet" "bys_sbn_az1_con" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az1_con"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az1-container"
  }
}

resource "aws_subnet" "bys_sbn_az2_con" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az2_con"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az2-container"
  }
}


resource "aws_subnet" "bys_sbn_az1_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az1_intelb"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az1-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az2_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az2_intelb"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az2-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az1_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az1_db"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az1-db"
  }
}

resource "aws_subnet" "bys_sbn_az2_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_az2_db"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-sbn-az2-db"
  }
}

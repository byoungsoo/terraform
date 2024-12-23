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
          "Name" = "${var.project_code}-${var.account}-${var.aws_region_code}-vpc" 
        }
}

// public subnets
resource "aws_subnet" "bys_sbn_az1_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1a_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az1-dmz"
  }
}

resource "aws_subnet" "bys_sbn_az2_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1b_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az2-dmz"
  }
}


resource "aws_subnet" "bys_sbn_az3_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1c_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az3"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az3-dmz"
  }
}

resource "aws_subnet" "bys_sbn_az4_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1d_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az4"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az4-dmz"
  }
}

resource "aws_subnet" "bys_sbn_az5_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1e_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az5"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az5-dmz"
  }
}


resource "aws_subnet" "bys_sbn_az6_dmz" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1f_dmz"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az6"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az6-dmz"
  }
}


// extelb
resource "aws_subnet" "bys_sbn_az1_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1a_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az1-extelb"
  }
}

resource "aws_subnet" "bys_sbn_az2_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1b_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az2-extelb"
  }
}

resource "aws_subnet" "bys_sbn_az3_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1c_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az3"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az3-extelb"
  }
}

resource "aws_subnet" "bys_sbn_az4_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1d_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az4"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az4-extelb"
  }
}

resource "aws_subnet" "bys_sbn_az5_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1e_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az5"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az5-extelb"
  }
}

resource "aws_subnet" "bys_sbn_az6_extelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1f_extelb"]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone["az6"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az6-extelb"
  }
}

// private subnets
resource "aws_subnet" "bys_sbn_az1_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1a_app"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az1-app"
  }
}

resource "aws_subnet" "bys_sbn_az2_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1b_app"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az2-app"
  }
}

resource "aws_subnet" "bys_sbn_az3_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1c_app"]
  availability_zone = var.availability_zone["az3"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az3-app"
  }
}

resource "aws_subnet" "bys_sbn_az4_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1d_app"]
  availability_zone = var.availability_zone["az4"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az4-app"
  }
}

resource "aws_subnet" "bys_sbn_az5_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1e_app"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az5-app"
  }
}

resource "aws_subnet" "bys_sbn_az6_app" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1f_app"]
  availability_zone = var.availability_zone["az6"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az6-app"
  }
}


resource "aws_subnet" "bys_sbn_az1_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1a_intelb"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az1-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az2_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1b_intelb"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az2-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az3_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1c_intelb"]
  availability_zone = var.availability_zone["az3"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az3-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az4_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1d_intelb"]
  availability_zone = var.availability_zone["az4"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az4-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az5_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1e_intelb"]
  availability_zone = var.availability_zone["az5"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az5-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az6_intelb" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1f_intelb"]
  availability_zone = var.availability_zone["az6"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az6-intelb"
  }
}

resource "aws_subnet" "bys_sbn_az1_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1a_db"]
  availability_zone = var.availability_zone["az1"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az1-db"
  }
}

resource "aws_subnet" "bys_sbn_az2_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1b_db"]
  availability_zone = var.availability_zone["az2"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az2-db"
  }
}

resource "aws_subnet" "bys_sbn_az3_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1c_db"]
  availability_zone = var.availability_zone["az3"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az3-db"
  }
}


resource "aws_subnet" "bys_sbn_az4_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1d_db"]
  availability_zone = var.availability_zone["az4"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az4-db"
  }
}

resource "aws_subnet" "bys_sbn_az5_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1e_db"]
  availability_zone = var.availability_zone["az5"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az5-db"
  }
}

resource "aws_subnet" "bys_sbn_az6_db" {
  vpc_id = aws_vpc.bys_vpc.id
  cidr_block = var.cidr_blocks["subnet_ue1f_db"]
  availability_zone = var.availability_zone["az6"]
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-sbn-az6-db"
  }
}


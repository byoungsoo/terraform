resource "aws_vpc" "smp_dev" { 
  cidr_block  = "10.10.0.0/16" 
  instance_tenancy = "default" 
  enable_dns_support                = true 
  enable_dns_hostnames              = true 
  enable_classiclink                = false 
  enable_classiclink_dns_support    = false 
  assign_generated_ipv6_cidr_block  = false 

  tags = { 
          "Name"      = "SMP-DEV-VPC" 
        }
}

// private subnets
resource "aws_subnet" "smp_dev_public_subnet1" {
  vpc_id = "${aws_vpc.smp_dev.id}"
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "smp_dev_public_subnet1"
  }
}

resource "aws_subnet" "smp_dev_public_subnet2" {
  vpc_id = "${aws_vpc.smp_dev.id}"
  cidr_block = "10.10.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "smp_dev_public_subnet2"
  }
}

// private subnets
resource "aws_subnet" "smp_dev_private_subnet1" {
  vpc_id = "${aws_vpc.smp_dev.id}"
  cidr_block = "10.10.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "smp_dev_private_subnet1"
  }
}

resource "aws_subnet" "smp_dev_private_subnet2" {
  vpc_id = "${aws_vpc.smp_dev.id}"
  cidr_block = "10.10.11.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "smp_dev_private_subnet2"
  }
}


// igw
resource "aws_internet_gateway" "smp_dev_igw" {
  vpc_id = "${aws_vpc.smp_dev.id}"

  tags = {
    Name = "main"
  }
}

// eip for NAT
resource "aws_eip" "smp_dev_nat_eip" {
  vpc = true
  depends_on = ["aws_internet_gateway.smp_dev_igw"]
}

// NAT gateway
resource "aws_nat_gateway" "smp_dev_nat" {
  allocation_id = "${aws_eip.smp_dev_nat_eip.id}"
  subnet_id = "${aws_subnet.smp_dev_public_subnet1.id}"
  depends_on = ["aws_internet_gateway.smp_dev_igw"]
}

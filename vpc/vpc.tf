#Naming Rule
#ProjectCode-Account-Resource-{att1}-{zone}

// vpc
resource "aws_vpc" "smp_dev_vpc" { 
  cidr_block  = "10.20.0.0/16" 
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

// public subnets
resource "aws_subnet" "smp_dev_sbn_az1_dmz" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "SMP-DEV-SBN-AZ1-DMZ"
  }
}

resource "aws_subnet" "smp_dev_sbn_az2_dmz" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "SMP-DEV-SBN-AZ2-DMZ"
  }
}

// private subnets
resource "aws_subnet" "smp_dev_sbn_az1_app" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "SMP-DEV-SBN-AZ1-APP"
  }
}

resource "aws_subnet" "smp_dev_sbn_az2_app" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.11.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "SMP-DEV-SBN-AZ2-APP"
  }
}

// private subnets
resource "aws_subnet" "smp_dev_sbn_az1_elb" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.12.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "SMP-DEV-SBN-AZ1-ELB"
  }
}

resource "aws_subnet" "smp_dev_sbn_az2_elb" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.13.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "SMP-DEV-SBN-AZ2-ELB"
  }
}

resource "aws_subnet" "smp_dev_sbn_az1_eks" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.14.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "SMP-DEV-SBN-AZ1-EKS"
  }
}

resource "aws_subnet" "smp_dev_sbn_az2_eks" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.15.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "SMP-DEV-SBN-AZ2-EKS"
  }
}


resource "aws_subnet" "smp_dev_sbn_az1_db" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.16.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "SMP-DEV-SBN-AZ1-DB"
  }
}

resource "aws_subnet" "smp_dev_sbn_az2_db" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  cidr_block = "10.20.17.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "SMP-DEV-SBN-AZ2-DB"
  }
}

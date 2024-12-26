
#ProjectCode-Account-Resource-{att1}-{zone}
// igw
resource "aws_internet_gateway" "bys_igw" {
  vpc_id = aws_vpc.bys_vpc_main.id
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-igw"
    auto-delete = "no"
  }
}

// eip for NAT
resource "aws_eip" "bys_natgw_eip" {
  domain              = "vpc"
  depends_on          = [aws_internet_gateway.bys_igw]

  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-eip-igw"
    auto-delete = "no"
  }
}

// NAT gateway
resource "aws_nat_gateway" "bys_natgw" {
  allocation_id       = aws_eip.bys_natgw_eip.id
  subnet_id           = aws_subnet.bys_prv_subnets[0].id
  depends_on          = [aws_internet_gateway.bys_igw]

  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-natgw"
    auto-delete = "no"
  }
}
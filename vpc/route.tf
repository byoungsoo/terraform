resource "aws_default_route_table" "smp_dev" {
  default_route_table_id = "${aws_vpc.smp_dev.default_route_table_id}"

  tags = {
    Name = "default"
  }
}


// route to internet
resource "aws_route" "smp_dev_internet_access" {
  route_table_id = "${aws_vpc.smp_dev.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.smp_dev_igw.id}"
}


// private route table
resource "aws_route_table" "smp_dev_private_route_table" {
  vpc_id = "${aws_vpc.smp_dev.id}"
  
  tags = {
    Name = "private"
  }
}

resource "aws_route" "private_route" {
  route_table_id = "${aws_route_table.smp_dev_private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.smp_dev_nat.id}"
}



// associate subnets to route tables
resource "aws_route_table_association" "smp_dev_public_subnet1_association" {
  subnet_id = "${aws_subnet.smp_dev_public_subnet1.id}"
  route_table_id = "${aws_vpc.smp_dev.main_route_table_id}"
}

resource "aws_route_table_association" "smp_dev_public_subnet2_association" {
  subnet_id = "${aws_subnet.smp_dev_public_subnet2.id}"
  route_table_id = "${aws_vpc.smp_dev.main_route_table_id}"
}

resource "aws_route_table_association" "smp_dev_private_subnet1_association" {
  subnet_id = "${aws_subnet.smp_dev_private_subnet1.id}"
  route_table_id = "${aws_route_table.smp_dev_private_route_table.id}"
}

resource "aws_route_table_association" "smp_dev_private_subnet2_association" {
  subnet_id = "${aws_subnet.smp_dev_private_subnet2.id}"
  route_table_id = "${aws_route_table.smp_dev_private_route_table.id}"
}

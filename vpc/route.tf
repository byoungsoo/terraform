//default route table
resource "aws_default_route_table" "smp_dev_rtb_default" {
  default_route_table_id = "${aws_vpc.smp_dev_vpc.default_route_table_id}"

  tags = {
    Name = "SMP-DEV-RTB-PUBLIC"
  }
}

// route to internet
resource "aws_route" "smp_dev_rt_public" {
  route_table_id = "${aws_vpc.smp_dev_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.smp_dev_igw.id}"
}


// private route table
resource "aws_route_table" "smp_dev_rtb_private" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"
  
  tags = {
    Name = "SMP-DEV-RTB-PRIVATE"
  }
}

resource "aws_route" "smp_dev_rt_private" {
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.smp_dev_nat.id}"
}



// associate subnets to route tables
resource "aws_route_table_association" "smp_dev_sbn_az1_dmz_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az1_dmz.id}"
  route_table_id = "${aws_vpc.smp_dev_vpc.main_route_table_id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az2_dmz_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az2_dmz.id}"
  route_table_id = "${aws_vpc.smp_dev_vpc.main_route_table_id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az1_app_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az1_app.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az2_app_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az2_app.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az1_elb_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az1_elb.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az2_elb_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az2_elb.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az1_eks_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az1_eks.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az2_eks_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az2_eks.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az1_db_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az1_db.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

resource "aws_route_table_association" "smp_dev_sbn_az2_db_association" {
  subnet_id = "${aws_subnet.smp_dev_sbn_az2_db.id}"
  route_table_id = "${aws_route_table.smp_dev_rtb_private.id}"
}

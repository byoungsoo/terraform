//default route table
resource "aws_default_route_table" "bys_rtb_default" {
  default_route_table_id = aws_vpc.bys_vpc.default_route_table_id

  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-rtb-public"
  }
}

// private route table
resource "aws_route_table" "bys_rtb_private" {
  vpc_id = aws_vpc.bys_vpc.id
  
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-rtb-private"
  }
}


// route to internet
resource "aws_route" "bys_rt_public" {
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.bys_igw.id
}

resource "aws_route" "bys_rt_private" {
  route_table_id = aws_route_table.bys_rtb_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.bys_nat.id
}


// associate subnets to public route tables
resource "aws_route_table_association" "bys_sbn_az1_dmz_association" {
  subnet_id = aws_subnet.bys_sbn_az1_dmz.id
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
}

resource "aws_route_table_association" "bys_sbn_az2_dmz_association" {
  subnet_id = aws_subnet.bys_sbn_az2_dmz.id
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
}

resource "aws_route_table_association" "bys_sbn_az1_extelb_association" {
  subnet_id = aws_subnet.bys_sbn_az1_extelb.id
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
}

resource "aws_route_table_association" "bys_sbn_az2_extelb_association" {
  subnet_id = aws_subnet.bys_sbn_az2_extelb.id
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
}


// associate subnets to private route tables
resource "aws_route_table_association" "bys_sbn_az1_app_association" {
  subnet_id = aws_subnet.bys_sbn_az1_app.id
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
}

resource "aws_route_table_association" "bys_sbn_az2_app_association" {
  subnet_id = aws_subnet.bys_sbn_az2_app.id
  route_table_id = aws_vpc.bys_vpc.main_route_table_id
}


resource "aws_route_table_association" "bys_sbn_az1_con_association" {
  subnet_id = aws_subnet.bys_sbn_az1_con.id
  route_table_id = aws_route_table.bys_rtb_private.id
}

resource "aws_route_table_association" "bys_sbn_az2_con_association" {
  subnet_id = aws_subnet.bys_sbn_az2_con.id
  route_table_id = aws_route_table.bys_rtb_private.id
}

resource "aws_route_table_association" "bys_sbn_az1_intelb_association" {
  subnet_id = aws_subnet.bys_sbn_az1_intelb.id
  route_table_id = aws_route_table.bys_rtb_private.id
}

resource "aws_route_table_association" "bys_sbn_az2_intelb_association" {
  subnet_id = aws_subnet.bys_sbn_az2_intelb.id
  route_table_id = aws_route_table.bys_rtb_private.id
}

resource "aws_route_table_association" "bys_sbn_az1_db_association" {
  subnet_id = aws_subnet.bys_sbn_az1_db.id
  route_table_id = aws_route_table.bys_rtb_private.id
}

resource "aws_route_table_association" "bys_sbn_az2_db_association" {
  subnet_id = aws_subnet.bys_sbn_az2_db.id
  route_table_id = aws_route_table.bys_rtb_private.id
}

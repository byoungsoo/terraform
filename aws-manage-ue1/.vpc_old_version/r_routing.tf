#Naming Rule
#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

// Route table
resource "aws_default_route_table" "bys_rt_table_default" {
  default_route_table_id = aws_vpc.bys_vpc_main.default_route_table_id

  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-rtb-default"
  }
}

resource "aws_route_table" "bys_rt_table_pub" {
  vpc_id = aws_vpc.bys_vpc_main.id
  
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-rtb-pub"
  }
}

resource "aws_route_table" "bys_rt_table_prv" {
  vpc_id = aws_vpc.bys_vpc_main.id
  
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-rtb-prv"
  }
}

resource "aws_route_table" "bys_rt_table_prv_only" {
  vpc_id = aws_vpc.bys_vpc_main.id
  
  tags = {
    Name = "${var.project_code}-${var.account}-${var.aws_region_code}-rtb-prvonly"
  }
}


// Route rule
resource "aws_route" "bys_rt_rule_pub" {
  route_table_id = aws_route_table.bys_rt_table_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.bys_igw.id
}

resource "aws_route" "bys_rt_rule_prv" {
  route_table_id = aws_route_table.bys_rt_table_prv.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.bys_natgw.id
}

// Associate subnets to public route tables
resource "aws_route_table_association" "bys_rt_association_pub" {
  for_each          = aws_subnet.bys_pub_subnets
  
  subnet_id         = each.value.id
  route_table_id    = aws_route_table.bys_rt_table_pub.id
}

// Associate subnets to private route tables
resource "aws_route_table_association" "bys_rt_association_prv" {
  for_each          = aws_subnet.bys_prv_subnets
  
  subnet_id         = each.value.id
  route_table_id    = aws_route_table.bys_rt_table_prv.id
}

// Associate subnets to private only route tables
resource "aws_route_table_association" "bys_rt_association_prv_only" {
  for_each          = aws_subnet.bys_prv_only_subnets
  
  subnet_id         = each.value.id
  route_table_id    = aws_route_table.bys_rt_table_prv_only.id
}
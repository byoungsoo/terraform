resource "aws_security_group" "sg_endpoint" {
  name   = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint"
  vpc_id = aws_vpc.example.id
  ingress = []
  egress  = []
  
  tags = {
    Name          = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint"
    auto-delete   ="no"
  }
}
resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.sg_endpoint.id

  cidr_ipv4   = "${local.vpc_cidr_block}"
  ip_protocol = "https"
  from_port   = 443
  to_port     = 443
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "sg_endpoint_block" {
  name   = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint-block"
  vpc_id = aws_vpc.example.id
  ingress = []
  egress  = []
  
  tags = {
    Name          = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint-block"
    auto-delete   ="no"
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
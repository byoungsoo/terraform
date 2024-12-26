#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
## sg_endpoint
resource "aws_security_group" "sg_endpoint" {
  name   = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint"
  vpc_id = "${local.vpc_id}"
  ingress = []
  egress  = []
  
  tags = {
    Name          = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint"
    auto-delete   ="no"
  }
}
resource "aws_vpc_security_group_ingress_rule" "sg_endpoint_ingress_rule_https" {
  security_group_id = aws_security_group.sg_endpoint.id

  cidr_ipv4   = "${local.vpc_cidr_block}"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "sg_endpoint_egress_rule_all" {
  security_group_id = aws_security_group.sg_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


## sg_endpoint_block
resource "aws_security_group" "sg_endpoint_block" {
  name   = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint-block"
  vpc_id = "${local.vpc_id}"
  ingress = []
  egress  = []
  
  tags = {
    Name          = "${var.project_code}-${var.account}-${var.aws_region_code}-sg-endpoint-block"
    auto-delete   ="no"
  }
}
resource "aws_vpc_security_group_egress_rule" "sg_endpoint_block_egress_rule_all" {
  security_group_id = aws_security_group.sg_endpoint_block.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
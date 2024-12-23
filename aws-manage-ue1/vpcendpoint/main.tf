#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

# Data
locals {
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr_block  = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  }



resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = "${local.vpc_id}"
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.sg_endpoint.id,
  ]
  subnet_ids = [
    aws_subnet.example1.id, aws_subnet.example2.id
  ]
  private_dns_enabled = true
  tags = { 
    Name        = "${var.project_code}-${var.account}-${var.aws_region_code}-endpoint-ec2" 
    auto-delete = "no"
  }
}
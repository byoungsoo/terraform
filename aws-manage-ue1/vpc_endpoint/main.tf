#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = "${local.vpc_id}"
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.sg_endpoint.id,
  ]
  subnet_ids = [
    "${local.sbn-app-az1}",
    "${local.sbn-app-az2}",
    "${local.sbn-app-az3}",
    "${local.sbn-app-az4}",
    "${local.sbn-app-az5}",
    "${local.sbn-app-az6}"
  ]
  private_dns_enabled = true
  tags = { 
    Name        = "${var.project_code}-${var.account}-${var.aws_region_code}-endpoint-ec2" 
    auto-delete = "no"
  }
}
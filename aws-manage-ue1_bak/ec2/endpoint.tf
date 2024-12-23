resource "aws_vpc_endpoint" "qdeveloper" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.q"

  vpc_endpoint_type = "Interface"
  
  security_group_ids = [
    aws_security_group.ptfe_service.id,
  ]

  subnet_ids          = [
    aws_subnet.bys_sbn_az1_app.id, aws_subnet.bys_sbn_az2_app.id,
    aws_subnet.bys_sbn_az3_app.id, aws_subnet.bys_sbn_az4_app.id,
    aws_subnet.bys_sbn_az5_app.id, aws_subnet.bys_sbn_az6_app.id
  ]

  private_dns_enabled = true

  tags = {
    auto-delete = "no"
  }
}


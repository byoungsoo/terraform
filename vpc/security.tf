//network acl default
resource "aws_default_network_acl" "SMP-DEV-NACL-DEFAULT" {
  default_network_acl_id = "${aws_vpc.smp_dev_vpc.default_network_acl_id}"
  
  subnet_ids = [
    "${aws_subnet.smp_dev_sbn_az1_dmz.id}",
    "${aws_subnet.smp_dev_sbn_az2_dmz.id}",
    
    "${aws_subnet.smp_dev_sbn_az1_app.id}",
    "${aws_subnet.smp_dev_sbn_az2_app.id}",

    "${aws_subnet.smp_dev_sbn_az1_eks.id}",
    "${aws_subnet.smp_dev_sbn_az2_eks.id}",

    "${aws_subnet.smp_dev_sbn_az1_db.id}",
    "${aws_subnet.smp_dev_sbn_az2_db.id}"    
  ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "default"
  }
}


// default security group
resource "aws_default_security_group" "smp_dev_sg_deafult" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SMP-DEV-SG-DEFAULT"
  }
}


// Basiton Host
resource "aws_security_group" "smp_dev_sg_bastion" {
  name = "SMP-DEV-SG-BASTION"
  description = "Security group for bastion instance"
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SMP-DEV-SG-BASTION"
  }
}

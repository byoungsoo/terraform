//network acl default
resource "aws_default_network_acl" "smp_dev_default" {
  default_network_acl_id = "${aws_vpc.smp_dev.default_network_acl_id}"

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


// network acl for public subnets
resource "aws_network_acl" "smp_dev_public" {
  vpc_id = "${aws_vpc.smp_dev.id}"
  subnet_ids = [
    "${aws_subnet.smp_dev_public_subnet1.id}",
    "${aws_subnet.smp_dev_public_subnet2.id}",
  ]

  tags = {
    Name = "public"
  }
}


// default security group
resource "aws_default_security_group" "smp_dev_default" {
  vpc_id = "${aws_vpc.smp_dev.id}"

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
    Name = "default"
  }
}


// Basiton Host
resource "aws_security_group" "smp_dev_bastion" {
  name = "bastion"
  description = "Security group for bastion instance"
  vpc_id = "${aws_vpc.smp_dev.id}"

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
    Name = "bastion"
  }
}

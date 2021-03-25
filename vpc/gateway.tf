#ProjectCode-Account-Resource-{att1}-{zone}
// igw
resource "aws_internet_gateway" "smp_dev_igw" {
  vpc_id = "${aws_vpc.smp_dev_vpc.id}"

  tags = {
    Name = "SMP-DEV-IGW"
  }
}

// eip for NAT
resource "aws_eip" "smp_dev_eip_nat" {
  vpc = true
  depends_on = [aws_internet_gateway.smp_dev_igw]

  tags = {
    Name = "IGW"
  }
}

// NAT gateway
resource "aws_nat_gateway" "smp_dev_nat" {
  allocation_id = "${aws_eip.smp_dev_eip_nat.id}"
  subnet_id = "${aws_subnet.smp_dev_sbn_az1_dmz.id}"
  depends_on = [aws_internet_gateway.smp_dev_igw]
}
smp_dev "aws_instance" "smp_dev_bastion" {
  ami = "${data.aws_ami.ubuntu.id}"
  availability_zone = "${aws_subnet.smp_dev_public_subnet1.availability_zone}"
  instance_type = "t3.micro"
  key_name = "YOUR-KEY-PAIR-NAME"
  vpc_security_group_ids = [
    "${aws_default_security_group.smp_dev_default.id}",
    "${aws_security_group.smp_dev_bastion.id}"
  ]
  subnet_id = "${aws_subnet.smp_dev_public_subnet1.id}"
  associate_public_ip_address = true

  tags {
    Name = "bastion"
  }
}

smp_dev "aws_eip" "smp_dev_bastion" {
  vpc = true
  instance = "${aws_instance.smp_dev_bastion.id}"
  depends_on = ["aws_internet_gateway.smp_dev_igw"]
}
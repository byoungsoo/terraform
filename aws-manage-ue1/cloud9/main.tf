resource "aws_cloud9_environment_ec2" "cloud9-dev" {
  instance_type                 = "${var.instance_type}"
  name                          = "${var.name}"
  image_id                      = "${var.image_id}"
  subnet_id                     = "${var.subnet_id}"
  # owner_arn                     = "${var.owner_arn}"
  connection_type               = "CONNECT_SSM"
  automatic_stop_time_minutes   = 60
  

  tags = {
    auto-delete = "no"
  }
}


data "aws_instance" "cloud9_instance" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
      aws_cloud9_environment_ec2.cloud9-dev.id
      ]
  }
}


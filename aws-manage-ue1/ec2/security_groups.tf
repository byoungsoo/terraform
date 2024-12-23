locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = ~

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_security_group" "example" {
  name   = "sg"
  vpc_id = aws_vpc.bys_vpc.id

  ingress = []
  egress  = []
}
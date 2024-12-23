locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ue1a_app_id=data.terraform_remote_state.vpc.outputs.subnet_ue1a_app_id
  subnet_ue1b_app_id=data.terraform_remote_state.vpc.outputs.subnet_ue1b_app_id
  subnet_ue1c_app_id=data.terraform_remote_state.vpc.outputs.subnet_ue1c_app_id
  subnet_ue1d_app_id=data.terraform_remote_state.vpc.outputs.subnet_ue1d_app_id
  subnet_ue1e_app_id=data.terraform_remote_state.vpc.outputs.subnet_ue1e_app_id
  subnet_ue1f_app_id=data.terraform_remote_state.vpc.outputs.subnet_ue1f_app_id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = ""

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



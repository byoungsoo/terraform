## Default
aws_region="us-east-1"
aws_region_code="ue1"
project_code = "bys"
account = "manage"

## vpc/subnet
cidr_blocks = {
  vpc = "10.120.0.0/16"
  subnet_ue1a_dmz = "10.120.1.0/24"
  subnet_ue1b_dmz = "10.120.2.0/24"
  subnet_ue1c_dmz = "10.120.3.0/24"
  subnet_ue1d_dmz = "10.120.4.0/24"
  subnet_ue1e_dmz = "10.120.5.0/24"
  subnet_ue1f_dmz = "10.120.6.0/24"

  subnet_ue1a_extelb = "10.120.11.0/24"
  subnet_ue1b_extelb = "10.120.12.0/24"
  subnet_ue1c_extelb = "10.120.13.0/24"
  subnet_ue1d_extelb = "10.120.14.0/24"
  subnet_ue1e_extelb = "10.120.15.0/24"
  subnet_ue1f_extelb = "10.120.16.0/24"

  subnet_ue1a_app = "10.120.20.0/22"
  subnet_ue1b_app = "10.120.24.0/22"
  subnet_ue1c_app = "10.120.28.0/22"
  subnet_ue1d_app = "10.120.32.0/22"
  subnet_ue1e_app = "10.120.36.0/22"
  subnet_ue1f_app = "10.120.40.0/22"

  subnet_ue1a_intelb = "10.120.51.0/24"
  subnet_ue1b_intelb = "10.120.52.0/24"
  subnet_ue1c_intelb = "10.120.53.0/24"
  subnet_ue1d_intelb = "10.120.54.0/24"
  subnet_ue1e_intelb = "10.120.55.0/24"
  subnet_ue1f_intelb = "10.120.56.0/24"
  
  subnet_ue1a_db = "10.120.61.0/24"
  subnet_ue1b_db = "10.120.62.0/24"
  subnet_ue1c_db = "10.120.63.0/24"
  subnet_ue1d_db = "10.120.64.0/24"
  subnet_ue1e_db = "10.120.65.0/24"
  subnet_ue1f_db = "10.120.66.0/24"
}


availability_zone = {
  az1 = "us-east-1a"
  az2 = "us-east-1b"
  az3 = "us-east-1c"
  az4 = "us-east-1d"
  az5 = "us-east-1e"
  az6 = "us-east-1f"
}
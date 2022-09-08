## vpc/subnet
project_code = "bys"
account = "shared"

cidr_blocks = {
  vpc = "10.10.0.0/16"
  subnet_az1_dmz = "10.10.1.0/24"
  subnet_az2_dmz = "10.10.2.0/24"

  subnet_az1_extelb = "10.10.11.0/24"
  subnet_az2_extelb = "10.10.12.0/24"

  subnet_az1_app = "10.10.21.0/24"
  subnet_az2_app = "10.10.22.0/24"

  subnet_az1_con = "10.10.31.0/24"
  subnet_az2_con = "10.10.32.0/24"

  subnet_az1_intelb = "10.10.41.0/24"
  subnet_az2_intelb = "10.10.42.0/24"

  subnet_az1_db = "10.10.41.0/24"
  subnet_az2_db = "10.10.42.0/24"
}


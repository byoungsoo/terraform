module "vpc" {
  source = "../../../module/vpc"

  vpc_name = ""
  vpc_cidr = "10.0.0.0/16"
}
# default
variable "aws_region" {}
variable "aws_region_code" {}
variable "project_code" {}
variable "account" {}

# vpc/subnet
variable "cidr_blocks" {
  type = map 
}

variable "availability_zone" {
  type = map
  default = {
      az1 = "us-east-1a"
      az2 = "us-east-1b"
      az3 = "us-east-1c"
      az4 = "us-east-1d"
      az5 = "us-east-1e"
      az6 = "us-east-1f"
  }
}


# default
variable "aws_region" {}
variable "aws_region_code" {}
variable "project_code" {}
variable "account" {}

# vpc/subnet
variable "vpc_cidr_blocks" {
  type = map
}

variable "pub_subnet_cidr_blocks" {
  type = list(map)
}

variable "prv_subnet_cidr_blocks" {
  type = list(map)
}

variable "prv_only_subnet_cidr_blocks" {
  type = list(map)
}



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
  type = list(list(string))
}

variable "prv_subnet_cidr_blocks" {
  type = list(list(string))
}

variable "prv_only_subnet_cidr_blocks" {
  type = list(list(string))
}


# vpc/subnet
variable "project_code" {}
variable "account" {}

variable "cidr_blocks" {
  type = map 
}

variable "availability_zone" {
  type = map
  default = {
    az1 = "ap-northeast-2a"
    az2 = "ap-northeast-2c"
  }
}

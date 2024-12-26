# VPC 
variable "vpc_cidr_blocks" {
  type = map
}

# Subnet
variable "subnet_cidr_blocks" {
    type = list(
      object({
        name      = string
        cidr_block = string
        az        = string
        type      = string
        })
    )
}
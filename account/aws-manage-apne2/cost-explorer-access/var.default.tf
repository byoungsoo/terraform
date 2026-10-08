################################################################################
# Default
################################################################################
variable "project_code" {
  type        = string
  description = "Project code for resource naming"
  default     = "bys"
}

variable "account" {
  type        = string
  description = "Account environment (manage | dev | shared)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_region_code" {
  type        = string
  description = "AWS AZ ID prefix region code (e.g. apne2)"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to every resource"
  default = {
    "Terraform"   = "true"
    "auto-delete" = "no"
  }
}

locals {
  common_resource_name = "${var.project_code}-${var.account}-${var.aws_region_code}"
}

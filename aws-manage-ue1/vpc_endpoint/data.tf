# https://developer.hashicorp.com/terraform/language/backend/local
data "terraform_remote_state" "vpc" {
	backend = "local" 
  
  config =  {
    	path = "../vpc/terraform.tfstate"
    }
}

# Data
locals {
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr_block  = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  sbn-app-az1  = data.terraform_remote_state.vpc.outputs.prv_subnet_ids.sbn-app-az1
  sbn-app-az2  = data.terraform_remote_state.vpc.outputs.prv_subnet_ids.sbn-app-az2
  sbn-app-az3  = data.terraform_remote_state.vpc.outputs.prv_subnet_ids.sbn-app-az3
  sbn-app-az4  = data.terraform_remote_state.vpc.outputs.prv_subnet_ids.sbn-app-az4
  sbn-app-az5  = data.terraform_remote_state.vpc.outputs.prv_subnet_ids.sbn-app-az5
  sbn-app-az6  = data.terraform_remote_state.vpc.outputs.prv_subnet_ids.sbn-app-az6
  }

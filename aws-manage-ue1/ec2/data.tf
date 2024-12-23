# data "terraform_remote_state" "vpc" {
#   backend = "s3"
#   config = {
#     bucket = "terraform-state-prod"
#     key    = "network/terraform.tfstate"
#     region = "us-east-1"
#   }
# }


data "terraform_remote_state" "vpc" {
	backend = "local" {
    	path = "../vpc/terraform.tfstate"
    }
}
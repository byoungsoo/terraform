data "terraform_remote_state" "vpc" {
	backend = "local" {
    	path = "../vpc/terraform.tfstate"
    }
}
# Resource Naming Rule
#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = "vpc-012e100b29d364995"
  security_group_ids = ["sg-03e6fb8fd633e1beb"]

  endpoints = {
    s3 = {
      # gateway endpoint
      service         = "s3"
      route_table_ids = ["rtb-010c20126d841b5c1", "rtb-0415e0cad88c36d86"]
      tags            = { Name = "s3.gateway.endpoint" }
    },
    guardduty = {
      service    = "guardduty"
      private_dns_enabled = true
      subnet_ids = ["subnet-0c7f1a6209a63d9cb", "subnet-0b1e027d00f39d765", "subnet-082db326c9b13f5e6", "subnet-031cdc214322da2dd", "subnet-0ed7d6d7dd9e41ce4", "subnet-04291fc384bf08c8c"]
      tags       = { Name = "guardduty.endpoint" }
    },
    guardduty-data = {
      service    = "guardduty-data"
      private_dns_enabled = true
      subnet_ids = ["subnet-0c7f1a6209a63d9cb", "subnet-0b1e027d00f39d765", "subnet-082db326c9b13f5e6", "subnet-031cdc214322da2dd", "subnet-0ed7d6d7dd9e41ce4", "subnet-04291fc384bf08c8c"]
      tags       = { Name = "guardduty-data.endpoint" }
    }
  }

  tags = {
    auto-delete = "no"
  }
}
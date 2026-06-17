# Resource Naming Rule
#${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}

module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = "vpc-0ca96cd5c37d3bae8"
  security_group_ids = ["sg-050357912262fb3e3"]

  endpoints = {
    # S3 Gateway endpoint
    # s3 = {
    #   service         = "s3"
    #   route_table_ids = ["rtb-07f2da51755e6c5d8", "rtb-04a58feb2f450f59e"]
    #   tags            = { Name = "s3.gateway.endpoint" }
    # },
    # Guardduty endpoint
    guardduty = {
      service    = "guardduty"
      private_dns_enabled = true
      subnet_ids = ["subnet-0ea5be4984975e8ed", "subnet-0b4076508ce121c27"]
      tags       = { Name = "guardduty.endpoint" }
    },
    guardduty-data = {
      service    = "guardduty-data"
      private_dns_enabled = true
      subnet_ids = ["subnet-0ea5be4984975e8ed", "subnet-0b4076508ce121c27"]
      tags       = { Name = "guardduty-data.endpoint" }
    },
    # ECS
    ecs = {
      service    = "ecs"
      private_dns_enabled = true
      subnet_ids = ["subnet-0ea5be4984975e8ed", "subnet-0b4076508ce121c27"]
      tags       = { Name = "ecs.endpoint" }
    },
    # EC2
    ec2 = {
      service    = "ec2"
      private_dns_enabled = true
      subnet_ids = ["subnet-0ea5be4984975e8ed", "subnet-0b4076508ce121c27"]
      tags       = { Name = "ec2.endpoint" }
    },
    # Xray
    xray = {
      service    = "xray"
      private_dns_enabled = true
      subnet_ids = ["subnet-0ea5be4984975e8ed", "subnet-0b4076508ce121c27"]
      tags       = { Name = "xray.endpoint" }
    }

  }

  tags = {
    auto-delete = "no"
  }
}
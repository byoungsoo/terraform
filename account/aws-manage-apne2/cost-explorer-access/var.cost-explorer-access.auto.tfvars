account         = "manage"
aws_region      = "ap-northeast-2"
aws_region_code = "apne2"

common_tags = {
  "Terraform"   = "true"
  "auto-delete" = "no"
  "Environment" = "manage"
}

cost_explorer_read_role_name = "CostExplorerReadRole"

# aws-cost-exporter on bys-dev-apne2-eks-main (Pod Identity role, terraform aws-dev-apne2/observability)
cost_explorer_trusted_role_arns = [
  "arn:aws:iam::558846430793:role/EKSCostExporterRole_Main",
]

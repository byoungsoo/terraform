account         = "dev"
aws_region      = "ap-northeast-2"
aws_region_code = "apne2"

common_tags = {
  "Terraform"   = "true"
  "auto-delete" = "no"
  "Environment" = "dev"
}

eks_cluster_name   = "bys-dev-apne2-eks-main"
bucket_name_suffix = "eks-main"

# App retention: Loki 744h (31d) / Tempo 168h (7d) / Mimir 31d
observability_stores = {
  "loki" = {
    namespace       = "loki"
    service_account = "loki"
    role_name       = "EKSLokiStorageRole_Main"
    # chunks live under tenant prefixes next to ruler data, so no bucket expiration (compactor retention only)
  }
  "tempo" = {
    namespace       = "tempo"
    service_account = "tempo"
    role_name       = "EKSTempoStorageRole_Main"
    expiration_days = 14
  }
  "mimir" = {
    namespace         = "mimir"
    service_account   = "mimir"
    role_name         = "EKSMimirStorageRole_Main"
    expiration_days   = 60
    expiration_prefix = "blocks/"
  }
}

aws_api_readers = {
  # Grafana CloudWatch datasource (Bedrock dashboard and other AWS service metrics)
  # https://grafana.com/docs/grafana/latest/datasources/aws-cloudwatch/#iam-policies
  "grafana-cloudwatch" = {
    namespace       = "grafana"
    service_account = "grafana"
    role_name       = "EKSGrafanaDataSourceRole_Main"
    actions = [
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetInsightRuleReport",
      "logs:DescribeLogGroups",
      "logs:GetLogGroupFields",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:GetQueryResults",
      "logs:GetLogEvents",
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "tag:GetResources",
      "oam:ListSinks",
      "oam:ListAttachedLinks",
    ]
  }
  # Cost Explorer exporter (AWS - Cost dashboard). Each CE API request is billed ($0.01).
  # Organization-wide costs come from the payer account: the exporter assumes CostExplorerReadRole
  # there (terraform aws-manage-apne2/cost-explorer-access). The local ce:* actions are a fallback
  # for dev-only costs when ASSUME_ROLE_ARN is unset.
  "aws-cost-exporter" = {
    namespace       = "monitoring"
    service_account = "aws-cost-exporter"
    role_name       = "EKSCostExporterRole_Main"
    actions = [
      "ce:GetCostAndUsage",
      "ce:GetCostForecast",
    ]
    assume_role_arns = ["arn:aws:iam::692806374063:role/CostExplorerReadRole"]
  }
}

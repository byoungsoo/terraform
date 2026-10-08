################################################################################
# Cost Explorer read role (assumed cross-account by the dev cost exporter)
################################################################################
data "aws_iam_policy_document" "cost_explorer_read_assume" {
  statement {
    effect = "Allow"
    # The caller holds an EKS Pod Identity session whose tags are transitive, so TagSession is required.
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "AWS"
      identifiers = var.cost_explorer_trusted_role_arns
    }
  }
}

resource "aws_iam_role" "cost_explorer_read" {
  name                 = var.cost_explorer_read_role_name
  description          = "Read-only organization-wide Cost Explorer access for member-account dashboards"
  assume_role_policy   = data.aws_iam_policy_document.cost_explorer_read_assume.json
  max_session_duration = 3600

  tags = merge(
    { "Name" = var.cost_explorer_read_role_name },
    var.common_tags,
  )
}

data "aws_iam_policy_document" "cost_explorer_read" {
  statement {
    sid       = "CostExplorerRead"
    effect    = "Allow"
    actions   = ["ce:GetCostAndUsage", "ce:GetCostForecast"]
    resources = ["*"]
  }

  # Account names for dashboard labels
  statement {
    sid       = "OrganizationsListAccounts"
    effect    = "Allow"
    actions   = ["organizations:ListAccounts"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cost_explorer_read" {
  name   = "CostExplorerRead"
  role   = aws_iam_role.cost_explorer_read.id
  policy = data.aws_iam_policy_document.cost_explorer_read.json
}

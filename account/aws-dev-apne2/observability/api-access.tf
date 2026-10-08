################################################################################
# AWS API readers (Grafana CloudWatch datasource, Cost Explorer exporter)
################################################################################
resource "aws_iam_role" "api_reader" {
  for_each = var.aws_api_readers

  name               = each.value.role_name
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume.json

  tags = merge(
    { "Name" = each.value.role_name },
    var.common_tags,
  )
}

data "aws_iam_policy_document" "api_reader" {
  for_each = var.aws_api_readers

  statement {
    sid       = "ReadOnlyApis"
    effect    = "Allow"
    actions   = each.value.actions
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "api_reader" {
  for_each = aws_iam_role.api_reader

  name   = "ReadOnlyApis"
  role   = each.value.id
  policy = data.aws_iam_policy_document.api_reader[each.key].json
}

resource "aws_eks_pod_identity_association" "api_reader" {
  for_each = var.aws_api_readers

  cluster_name    = var.eks_cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = aws_iam_role.api_reader[each.key].arn

  tags = var.common_tags
}

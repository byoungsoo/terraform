data "aws_caller_identity" "current" {}

################################################################################
# S3 Buckets
################################################################################
resource "aws_s3_bucket" "this" {
  for_each = var.observability_stores

  bucket = "${local.common_resource_name}-s3-${var.bucket_name_suffix}-${each.key}"

  tags = merge(
    { "Name" = "${local.common_resource_name}-s3-${var.bucket_name_suffix}-${each.key}" },
    var.common_tags,
  )
}

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    id     = "abort-incomplete-multipart-upload"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = var.observability_stores[each.key].abort_multipart_days
    }
  }

  dynamic "rule" {
    for_each = var.observability_stores[each.key].expiration_days != null ? [1] : []

    content {
      id     = "expire-data-safety-net"
      status = "Enabled"

      filter {
        prefix = var.observability_stores[each.key].expiration_prefix
      }

      expiration {
        days = var.observability_stores[each.key].expiration_days
      }
    }
  }
}

data "aws_iam_policy_document" "bucket_tls_only" {
  for_each = aws_s3_bucket.this

  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      each.value.arn,
      "${each.value.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id
  policy = data.aws_iam_policy_document.bucket_tls_only[each.key].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

################################################################################
# IAM Roles (EKS Pod Identity)
################################################################################
data "aws_iam_policy_document" "pod_identity_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.observability_stores

  name               = each.value.role_name
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume.json

  tags = merge(
    { "Name" = each.value.role_name },
    var.common_tags,
  )
}

data "aws_iam_policy_document" "bucket_access" {
  for_each = aws_s3_bucket.this

  statement {
    sid       = "ListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [each.value.arn]
  }

  statement {
    sid    = "ObjectReadWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging",
    ]
    resources = ["${each.value.arn}/*"]
  }
}

resource "aws_iam_role_policy" "bucket_access" {
  for_each = aws_iam_role.this

  name   = "S3BucketAccess"
  role   = each.value.id
  policy = data.aws_iam_policy_document.bucket_access[each.key].json
}

################################################################################
# Pod Identity Associations
################################################################################
resource "aws_eks_pod_identity_association" "this" {
  for_each = var.observability_stores

  cluster_name    = var.eks_cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = aws_iam_role.this[each.key].arn

  tags = var.common_tags
}

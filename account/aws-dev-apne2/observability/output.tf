output "bucket_names" {
  description = "S3 bucket name per backend (loki | tempo | mimir)"
  value       = { for k, b in aws_s3_bucket.this : k => b.bucket }
}

output "role_arns" {
  description = "IAM role ARN per backend"
  value       = { for k, r in aws_iam_role.this : k => r.arn }
}

output "pod_identity_association_ids" {
  description = "Pod Identity association ID per backend"
  value       = { for k, a in aws_eks_pod_identity_association.this : k => a.association_id }
}

################################################################################
# Observability (LGTM object storage)
################################################################################
variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster that runs the LGTM stack (Pod Identity associations are created here)"
}

variable "bucket_name_suffix" {
  type        = string
  description = "Identifier inserted into bucket names to separate them from other clusters' buckets (e.g. eks-main)"
}

variable "observability_stores" {
  type = map(object({
    namespace            = string
    service_account      = string
    role_name            = string
    expiration_days      = optional(number)
    expiration_prefix    = optional(string, "")
    abort_multipart_days = optional(number, 7)
  }))
  description = <<-EOT
    One entry per backend (key = loki | tempo | mimir). Creates an S3 bucket, an IAM role scoped to that
    bucket, and a Pod Identity association. expiration_days is only a safety net behind the app's own
    retention; leave it null when config objects (ruler, alertmanager) share the bucket without a prefix.
  EOT
}

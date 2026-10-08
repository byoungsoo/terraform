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

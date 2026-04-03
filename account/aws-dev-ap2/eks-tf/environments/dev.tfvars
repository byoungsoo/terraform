# Project Configuration
project_code    = "bys"
account         = "dev"
aws_region      = "ap-northeast-2"
aws_region_code = "ap2"

# Common Tags
common_tags = {
  auto-delete = "no"
  Terraform   = "true"
  Environment = "dev"
}

# Network
vpc_id             = "vpc-0ca96cd5c37d3bae8"
private_subnet_ids = ["subnet-0bbd4c134a3589aee", "subnet-0905f706c84047310", "subnet-0299d5e7a4d5b7615", "subnet-011d63d192c05c6a3"]

# EKS Cluster Configuration
eks_cluster_name          = "bys-dev-ap2-eks-tf"
eks_cluster_version       = "1.35"
eks_cluster_role_name     = "EKSClusterRole"
eks_public_access_cidrs   = ["0.0.0.0/0"]
eks_log_types             = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
eks_log_retention_in_days = 545

# EKS Node Group Configuration
ng_al2023_x86_c5large_name           = "ng-al2023-x86-c5large"
ng_al2023_x86_c5large_role_name      = "AmazonEKSWorkerNodeRole"
ng_al2023_x86_c5large_instance_types = ["c5.xlarge"]
ng_al2023_x86_c5large_ami_type       = "AL2023_x86_64_STANDARD"

# Access Entries
karpenter_node_role_name     = "KarpenterNodeRole"
access_entry_admin_role_name = "AdminDevAccountRole"
access_entry_admin_user_name = "byoungsoo"

# EKS Addons
eks_addons = {
  "vpc-cni" = {
    addon_version = "v1.21.1-eksbuild.3"
  }
  "kube-proxy" = {
    addon_version = "v1.35.0-eksbuild.2"
  }
  "coredns" = {
    addon_version = "v1.13.2-eksbuild.1"
  }
  "eks-pod-identity-agent" = {
    addon_version = "v1.3.4-eksbuild.1"
  }
  "aws-ebs-csi-driver" = {
    addon_version                = "v1.45.0-eksbuild.1"
    pod_identity_role_name       = "AmazonEKS_EBS_CSI_DriverRole_PodIdentity"
    pod_identity_service_account = "ebs-csi-controller-sa"
  }
}

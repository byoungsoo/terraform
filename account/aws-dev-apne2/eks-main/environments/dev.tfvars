# Project Configuration
project_code    = "bys"
account         = "dev"
aws_region      = "ap-northeast-2"
aws_region_code = "apne2"

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
eks_cluster_name          = "bys-dev-apne2-eks-main"
eks_cluster_version       = "1.36"
eks_cluster_role_name     = "EKSClusterRole"
eks_public_access_cidrs   = ["0.0.0.0/0"]
eks_log_types             = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
eks_log_retention_in_days = 545

# EKS Node Group Configuration
ng_al2023_x86_c5large_name           = "ng-al2023-x86-c52large-v1"
ng_al2023_x86_c5large_role_name      = "AmazonEKSWorkerNodeRole"
ng_al2023_x86_c5large_instance_types = ["c5.2xlarge"]
ng_al2023_x86_c5large_ami_type       = "AL2023_x86_64_STANDARD"
ng_al2023_x86_c5large_desired_size   = 2
ng_al2023_x86_c5large_min_size       = 2
ng_al2023_x86_c5large_max_size       = 2

# Access Entries
karpenter_node_role_name     = "KarpenterNodeRole"
access_entry_admin_role_name = "AdminDevAccountRole"
access_entry_admin_user_name = "byoungsoo"



# ----------------------------------------------------------------------------------------
# addon_name                       serviceAccount          recommendedManagedPolicies #  | 
# ----------------------------------------------------------------------------------------
# vpc-cni                          aws-node                AmazonEKS_CNI_Policy
# coredns                          -                       -
# kube-proxy                       -                       -
# eks-pod-identity-agent           -                       -
# aws-ebs-csi-driver               ebs-csi-controller-sa   AmazonEBSCSIDriverPolicy
# aws-efs-csi-driver               efs-csi-controller-sa   AmazonEFSCSIDriverPolicy
# aws-mountpoint-s3-csi-driver     s3-csi-driver-sa        AmazonS3FullAccess
# snapshot-controller              -                       -
# aws-guardduty-agent              -                       -
# amazon-cloudwatch-observability  cloudwatch-agent        CloudWatchAgentServerPolicy
# adot                             adot-col-prom-metrics   AmazonPrometheusRemoteWriteAccess, CloudWatchAgentServerPolicy
#                                  adot-col-otlp-ingest    AWSXrayWriteOnlyAccess
#                                  adot-col-container-logs CloudWatchAgentServerPolicy
# ----------------------------------------------------------------------------------------
/*
for addon in vpc-cni kube-proxy coredns eks-pod-identity-agent aws-ebs-csi-driver amazon-cloudwatch-observability; do
  latest=$(aws eks describe-addon-versions --addon-name $addon --kubernetes-version 1.35 --region ap-northeast-2 --query "addons[0].addonVersions[0].addonVersion" --output text 2>/dev/null)
  printf "%-40s %s\n" "$addon" "$latest"
done
*/
# EKS Addons
eks_addons = {
  "vpc-cni" = {
    addon_version = "v1.23.2-eksbuild.1"
  }
  "kube-proxy" = {
    addon_version = "v1.36.0-eksbuild.45"
  }
  "coredns" = {
    addon_version        = "v1.14.7-eksbuild.10"
    configuration_values = <<-EOT
      {
        "autoScaling": {
          "enabled": true,
          "minReplicas": 3,
          "maxReplicas": 10
        },
        "resources": {
          "requests": { "cpu": "100m", "memory": "128Mi" },
          "limits": { "cpu": "500m", "memory": "256Mi" }
        },
        "affinity": {
          "nodeAffinity": {
            "requiredDuringSchedulingIgnoredDuringExecution": {
              "nodeSelectorTerms": [{
                "matchExpressions": [
                  { "key": "kubernetes.io/os", "operator": "In", "values": ["linux"] },
                  { "key": "kubernetes.io/arch", "operator": "In", "values": ["amd64", "arm64"] }
                ]
              }]
            }
          }
        },
        "topologySpreadConstraints": [
          {
            "maxSkew": 1,
            "topologyKey": "kubernetes.io/hostname",
            "whenUnsatisfiable": "ScheduleAnyway",
            "labelSelector": { "matchLabels": { "k8s-app": "kube-dns" } }
          },
          {
            "maxSkew": 1,
            "topologyKey": "topology.kubernetes.io/zone",
            "whenUnsatisfiable": "ScheduleAnyway",
            "labelSelector": { "matchLabels": { "k8s-app": "kube-dns" } }
          }
        ]
      }
    EOT
  }
  "eks-pod-identity-agent" = {
    addon_version = "v1.4.0-eksbuild.3"
  }
  "aws-ebs-csi-driver" = {
    addon_version                = "v1.63.0-eksbuild.1"
    pod_identity_role_name       = "AmazonEKS_EBS_CSI_DriverRole_PodIdentity"
    pod_identity_service_account = "ebs-csi-controller-sa"
  }
  # amazon-cloudwatch-observability removed: replaced by the LGTM stack + OpenTelemetry Operator (ArgoCD)
}

# Pod Identity Associations
pod_identity_associations = {
  "karpenter" = {
    namespace       = "karpenter"
    service_account = "karpenter"
    role_name       = "KarpenterControllerRole"
  }
  "aws-load-balancer-controller" = {
    namespace       = "kube-system"
    service_account = "aws-load-balancer-controller"
    role_name       = "AmazonEKSLoadBalancerControllerRole"
  }
}

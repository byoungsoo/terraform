# Project Configuration
project_code    = "bys"
account         = "dev"
aws_region      = "us-east-1"
aws_region_code = "ue1"

# Common Tags
common_tags = {
  auto-delete = "no"
  Terraform   = "true"
  Environment = "dev"
}

# EKS Cluster Configuration
eks_cluster_name    = "bys-dev-ue1-eks-main"
eks_cluster_version = "1.32"
eks_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

# EKS Node Group Configuration
ng_al2023_x86_c5large_name           = "ng-al2023-x86-c5large"
ng_al2023_x86_c5large_instance_types = ["c5.xlarge"]
ng_al2023_x86_c5large_ami_type       = "AL2023_x86_64_STANDARD"

# EKS Addons Versions (for EKS 1.32)
vpc_cni_addon_version            = "v1.19.6-eksbuild.7"
kube_proxy_addon_version         = "v1.32.6-eksbuild.2"
coredns_addon_version            = "v1.11.4-eksbuild.14"
pod_identity_agent_addon_version = "v1.3.4-eksbuild.1"
ebs_csi_driver_addon_version     = "v1.45.0-eksbuild.1"

# CoreDNS Configuration
coredns_configuration_values = {
  autoScaling = {
    enabled     = true
    minReplicas = 3
    maxReplicas = 10
  }
  affinity = {
    nodeAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = {
        nodeSelectorTerms = [
          {
            matchExpressions = [
              {
                key      = "eks.amazonaws.com/nodegroup"
                operator = "Exists"
              }
            ]
          }
        ]
      }
    }
    podAntiAffinity = {
      preferredDuringSchedulingIgnoredDuringExecution = [
        {
          podAffinityTerm = {
            labelSelector = {
              matchExpressions = [
                {
                  key      = "k8s-app"
                  operator = "In"
                  values   = ["kube-dns"]
                }
              ]
            }
            topologyKey = "kubernetes.io/hostname"
          }
          weight = 100
        }
      ]
    }
  }
}

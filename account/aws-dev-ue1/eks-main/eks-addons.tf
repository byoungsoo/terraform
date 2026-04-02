################################################################################
# EKS Addons
################################################################################

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.19.6-eksbuild.7"
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = module.vpc_cni_irsa.iam_role_arn

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "kube-proxy"
  addon_version = "v1.32.6-eksbuild.2"

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "coredns"
  addon_version               = "v1.11.4-eksbuild.14"
  resolve_conflicts_on_update = "PRESERVE"
  
  configuration_values = jsonencode({
    "autoScaling": {
      "enabled": true,
      "minReplicas": 3,
      "maxReplicas": 10
    },
    "affinity": {
      "nodeAffinity": {
        "requiredDuringSchedulingIgnoredDuringExecution": {
          "nodeSelectorTerms": [
            {
              "matchExpressions": [
                {
                  "key": "eks.amazonaws.com/nodegroup",
                  "operator": "Exists"
                }
              ]
            }
          ]
        }
      },
      "podAntiAffinity": {
        "preferredDuringSchedulingIgnoredDuringExecution": [
          {
            "podAffinityTerm": {
              "labelSelector": {
                "matchExpressions": [
                  {
                    "key": "k8s-app",
                    "operator": "In",
                    "values": [
                      "kube-dns"
                    ]
                  }
                ]
              },
              "topologyKey": "kubernetes.io/hostname"
            },
            "weight": 100
          }
        ]
      }
    }
  })

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.4-eksbuild.1"

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.45.0-eksbuild.1"
  resolve_conflicts_on_update = "PRESERVE"

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}


resource "aws_eks_pod_identity_association" "ebs_csi_driver_identity" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn = "arn:aws:iam::558846430793:role/AmazonEKS_EBS_CSI_DriverRole_PodIdentity"
}

resource "aws_eks_pod_identity_association" "aws_lbc_identity" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn = "arn:aws:iam::558846430793:role/AmazonEKSLoadBalancerControllerRole"
}
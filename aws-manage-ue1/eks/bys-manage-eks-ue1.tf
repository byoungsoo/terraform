module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "bys-manage-eks-ue1"
  cluster_version = "1.31"

  bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Auth
  authentication_mode = "API_AND_CONFIG_MAP"

  # Log
  cluster_enabled_log_types = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = 545

  # Optional
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = "${local.vpc_id}"
  subnet_ids               = [
                               "${local.sbn-app-az1}", 
                               "${local.sbn-app-az2}", 
                               "${local.sbn-app-az3}", 
                               "${local.sbn-app-az4}", 
                               "${local.sbn-app-az6}"
                             ]
  control_plane_subnet_ids = [
                               "${local.sbn-app-az1}", 
                               "${local.sbn-app-az2}", 
                               "${local.sbn-app-az3}", 
                               "${local.sbn-app-az4}", 
                               "${local.sbn-app-az6}"
                             ]

  eks_managed_node_groups = {
    ng-al2023-x86-c5large = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["c5.large"]
      min_size     = 2
      max_size     = 10
      desired_size = 2

      subnet_ids = [
                      "${local.sbn-app-az1}", 
                      "${local.sbn-app-az2}", 
                      "${local.sbn-app-az3}", 
                      "${local.sbn-app-az4}", 
                      "${local.sbn-app-az6}"
                    ]
      cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
      vpc_security_group_ids            = [module.eks.node_security_group_id]
      tags = {
        auto-delete = "no"
        Terraform   = "true"
      }
    }
  }

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }

  access_entries = {
    # One access entry with a policy associated
    ng-al2023-x86-c5large = {
      user_name         = "system:node:{{EC2PrivateDNSName}}"
      kubernetes_groups = ["system:nodes"]
      type              = "EC2_LINUX"
      principal_arn     = module.eks.eks_managed_node_groups.ng-al2023-x86-c5large.iam_role_arn
    }
  }
}


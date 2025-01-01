locals {
  # Resource Naming Rule
  #${var.project_code}-${var.account}-${var.aws_region_code}-resource-{az}-{name}
  project_code = "bys"
  account = "dev"
  aws_region = "us-east-1"
  aws_region_code = "ue1"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "bys-dev-ue1-eks-main"
  cluster_version = "1.31"

  bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
    eks-pod-identity-agent = {} 
  }

  # Optional
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_tags = {
    Name = "bys-dev-ue1-eks-main"
  }

  # CloudWatch Log
  cluster_enabled_log_types = [ "audit", "api", "authenticator", "controllerManager", "scheduler"]
  create_cloudwatch_log_group = true
  cloudwatch_log_group_retention_in_days = 545
  cloudwatch_log_group_class = STANDARD


  # Networking
  vpc_id = "vpc-012e100b29d364995"
  control_plane_subnet_ids = ["subnet-0c7f1a6209a63d9cb", "subnet-0b1e027d00f39d765", "subnet-082db326c9b13f5e6", "subnet-031cdc214322da2dd", "subnet-04291fc384bf08c8c"]
  subnet_ids               = ["subnet-0c7f1a6209a63d9cb", "subnet-0b1e027d00f39d765", "subnet-082db326c9b13f5e6", "subnet-031cdc214322da2dd", "subnet-04291fc384bf08c8c"]

  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  
  # EKS Managed Node Group(s)
  create_node_iam_role = true

  eks_managed_node_groups = {
    ng-al2023-x86-c5large = {
        # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["c5.xlarge"]

        min_size     = 2
        max_size     = 2
        desired_size = 2
    },
    ng-al2023-x86-m5large = {
        # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["m5.xlarge"]

        min_size     = 2
        max_size     = 2
        desired_size = 2
      }
  }


  ################################################################################
  # Access Entry
  ################################################################################
  authentication_mode = "API_AND_CONFIG_MAP"

  access_entries = {
    # One access entry with a policy associated
    ng-al2023-x86-c5large = {
      principal_arn = module.eks.eks_managed_node_groups.ng-al2023-x86-c5large.iam_role_arn
      type = "EC2_LINUX"
    },
    ng-al2023-x86-m5large = {
      principal_arn = module.eks.eks_managed_node_groups.ng-al2023-x86-m5large.iam_role_arn
      type = "EC2_LINUX"
    },
    admin_role = {
      principal_arn = "arn:aws:iam::558846430793:role/AdminDevAccountRole"
      type = "STANDARD"
      policy_associations = {
        admin_role = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      },
    admin_user = {
      principal_arn = "arn:aws:iam::558846430793:user/byoungsoo"
      type = "STANDARD"
      policy_associations = {
        admin_role = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}

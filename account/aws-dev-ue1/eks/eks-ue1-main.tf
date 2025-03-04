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
    vpc-cni = {
      resolve_conflicts_on_update = "PRESERVE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      addon_version = "v1.19.0-eksbuild.1"
    }
    
    kube-proxy = {
      addon_version = "v1.31.2-eksbuild.3"
    }
    
    coredns = {
      addon_version = "v1.11.3-eksbuild.1"
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
    }
    eks-pod-identity-agent = {
      addon_version = "v1.3.4-eksbuild.1"
    }

    aws-ebs-csi-driver = {
      addon_version = "v1.38.1-eksbuild.1"
      resolve_conflicts_on_update = "PRESERVE"
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  # Optional
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = false

  cluster_tags = {
    Name = "bys-dev-ue1-eks-main"
  }

  # CloudWatch Log
  cluster_enabled_log_types = [ "audit", "api", "authenticator", "controllerManager", "scheduler"]
  create_cloudwatch_log_group = false
  cloudwatch_log_group_retention_in_days = 545
  cloudwatch_log_group_class = "STANDARD"


  # Networking
  vpc_id = "vpc-012e100b29d364995"
  control_plane_subnet_ids = ["subnet-0c7f1a6209a63d9cb", "subnet-0b1e027d00f39d765", "subnet-082db326c9b13f5e6", "subnet-031cdc214322da2dd", "subnet-04291fc384bf08c8c"]
  subnet_ids               = ["subnet-0c7f1a6209a63d9cb", "subnet-0b1e027d00f39d765", "subnet-082db326c9b13f5e6", "subnet-031cdc214322da2dd", "subnet-04291fc384bf08c8c"]

  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  
  # EKS Managed Node Group(s)
  create_node_iam_role = true

  eks_managed_node_groups = {
    ng_al2023_x86_c5large = {
        # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["c5.xlarge"]

        min_size     = 0
        max_size     = 1
        desired_size = 1

        taints = {
          dedicated = {
            key    = "test"
            value  = "test"
            effect = "NO_SCHEDULE"
          }
        }

    }
    # ng-al2023-x86-m5large = {
    #     # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    #     ami_type       = "AL2023_x86_64_STANDARD"
    #     instance_types = ["m5.xlarge"]

    #     min_size     = 2
    #     max_size     = 2
    #     desired_size = 2
    #   }
  }
  node_security_group_additional_rules = {
    source_self = {
      description = "Self"
      protocol    = "all"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    # source_control_plane = {
    #   security_group_id = module.eks.eks_managed_node_groups.ng_al2023_x86_c5large.node_security_group_id
    #   description = "Node to source EKS cluster"
    #   protocol    = "all"
    #   from_port   = 0
    #   to_port     = 0
    #   type        = "ingress"
    #   source_security_group_id = module.eks.cluster_security_group_id
    # }
  }

  ################################################################################
  # Access Entry
  ################################################################################
  authentication_mode = "API_AND_CONFIG_MAP"

  access_entries = {
    # One access entry with a policy associated
    # ng_al2023_x86_c5large = {
    #   principal_arn = module.eks.eks_managed_node_groups.ng_al2023_x86_c5large.iam_role_arn
    #   type = "EC2_LINUX"
    # },
    # ng_al2023_x86_m5large = {
    #   principal_arn = module.eks.eks_managed_node_groups.ng_al2023_x86_m5large.iam_role_arn
    #   type = "EC2_LINUX"
    # },
    admin_role = {
      principal_arn = "arn:aws:iam::558846430793:role/AdminDevAccountRole"
      type = "STANDARD"
      policy_associations = {
        cluster_role1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    admin_user = {
      principal_arn = "arn:aws:iam::558846430793:user/byoungsoo"
      type = "STANDARD"
      policy_associations = {
        cluster_role2 = {
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


module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "AmazonEKS_VPC_CNI_Role_${module.eks.cluster_name}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}

module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "AmazonEKS_EBS_CSI_DriverRole_${module.eks.cluster_name}"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    auto-delete = "no"
    Terraform   = "true"
  }
}


# resource "aws_autoscaling_group_tag" "auto_delete" {
#   for_each = toset([for asg_name in module.eks.eks_managed_node_groups_autoscaling_group_names : asg_name])
#   autoscaling_group_name = each.value

#   tag {
#     key   = "auto-delete"
#     value = "no"
#     propagate_at_launch = true
#   }
# }

resource "aws_autoscaling_group_tag" "auto_delete" {
  for_each = {for mng, info in module.eks.eks_managed_node_groups : mng => info}
  autoscaling_group_name = each.value.node_group_autoscaling_group_names[0]

  tag {
    key   = "auto-start"
    value = "yes"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "asg_name" {
  for_each = {for mng, info in module.eks.eks_managed_node_groups : mng => info}
  autoscaling_group_name = each.value.node_group_autoscaling_group_names[0]

  tag {
    key   = "Name"
    value = "${module.eks.cluster_name}-${replace(module.eks.eks_managed_node_groups[each.key].launch_template_name, "_", "-")}"
    propagate_at_launch = true
  }
}
# Existing AWS Resources (Sensitive Information)
# DO NOT commit this file to Git

vpc_id                  = "vpc-0ca96cd5c37d3bae8"
private_app3_subnet_ids = ["subnet-0bbd4c134a3589aee", "subnet-0bbd4c134a3589aee", "subnet-0bbd4c134a3589aee", "subnet-011d63d192c05c6a3"]

# IAM Role ARNs (Contains AWS Account ID)
eks_cluster_iam_role_arn          = "arn:aws:iam::558846430793:role/EKSClusterRole"
ng_al2023_x86_c5large_iam_role_arn = "arn:aws:iam::558846430793:role/AmazonEKSWorkerNodeRole"
karpenter_node_role_arn           = "arn:aws:iam::558846430793:role/KarpenterNodeRole-bys-dev-ap2-eks-main"
ebs_csi_driver_role_arn           = "arn:aws:iam::558846430793:role/AmazonEKS_EBS_CSI_DriverRole_PodIdentity"
aws_lbc_role_arn                  = "arn:aws:iam::558846430793:role/AmazonEKSLoadBalancerControllerRole"

# Access Entries (Contains AWS Account ID and User Names)
access_entry_admin_role = "arn:aws:iam::558846430793:role/AdminDevAccountRole"
access_entry_admin_user = "arn:aws:iam::558846430793:user/byoungsoo"

# Example Secret Variables File
# Copy this file to dev.secret.tfvars and fill in your actual values
# DO NOT commit files with actual values to Git

# Existing AWS Resources
vpc_id                  = "vpc-xxxxxxxxxxxxxxxxx"
private_app3_subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]

# IAM Role ARNs
eks_cluster_iam_role_arn            = "arn:aws:iam::ACCOUNT_ID:role/EKSClusterRole"
ng_al2023_x86_c5large_iam_role_arn = "arn:aws:iam::ACCOUNT_ID:role/AmazonEKSWorkerNodeRole"
karpenter_node_role_arn            = "arn:aws:iam::ACCOUNT_ID:role/KarpenterNodeRole-PROJECT-ENV-REGION-eks-main"
ebs_csi_driver_role_arn            = "arn:aws:iam::ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole_PodIdentity"
aws_lbc_role_arn                   = "arn:aws:iam::ACCOUNT_ID:role/AmazonEKSLoadBalancerControllerRole"

# Access Entries
access_entry_admin_role = "arn:aws:iam::ACCOUNT_ID:role/AdminRole"
access_entry_admin_user = "arn:aws:iam::ACCOUNT_ID:user/USERNAME"

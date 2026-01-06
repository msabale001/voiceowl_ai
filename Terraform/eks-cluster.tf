
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "my-cluster"
  kubernetes_version = "1.33"

  #Cluster IAM Role
  iam_role_arn = aws_iam_role.eks_cluster_role.arn


  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    dev = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      iam_role_arn = aws_iam_role.eks_nodegroup_role.arn
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  #Dependency on IAM roles
  depends_on = [
    aws_iam_role.eks_cluster_role,
    aws_iam_role.eks_nodegroup_role,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_nodegroup_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_nodegroup_AmazonEKS_CNI_Policy
  ]
}

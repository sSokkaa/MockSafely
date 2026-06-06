module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mocksafely-telemetry-cluster"
  cluster_version = "1.35"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # API access is locked to my local IP to allow Helm deployment. Would use CI/CD in production or VPN
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["97.69.56.250/32"]

  enable_irsa = true

  eks_managed_node_groups = {
    ms_telemetry_nodes = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      # Spot minimizes demo costs. You could utilize Karpenter in production to handle lifecycle management
      capacity_type = "SPOT"
    }
  }
}
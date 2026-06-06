module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8.0"

  name = "mocksafely-telemetry-vpc"
  cidr = "10.0.0.0/22"

  azs             = ["us-east-1a", "us-east-1b"]

  # Hosts EKS
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  # Hosts NGW and Kubernetes provisioned ALBs
  public_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = true

  # Chosen to reduce costs for demo
  single_nat_gateway = true
}
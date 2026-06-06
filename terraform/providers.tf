# Pinned terraform to 1.15.5 (LTS as of 6-6-26) to prevent syntax deprecations. 
terraform {
  required_version = "~> 1.15.5"
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    helm       = { source = "hashicorp/helm", version = "~> 2.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.0" }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "mocksafely"

  # Default tags used to ensure consistency and reduce repetitive code, would use specific tags injected in resource if applicable.
  default_tags {
    tags = {
      Environment = "Demo"
      Project     = "Mock Safely Telemetry"
      Repository  = "https://github.com/sSokkaa/MockSafely"
      ManagedBy   = "Terraform"
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
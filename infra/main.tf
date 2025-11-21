provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.0.0"
  name = "photoshare-vpc"
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]
}

# Create ECR repo
resource "aws_ecr_repository" "frontend" {
  name = "photos-frontend"
}

# EKS cluster (you can use eks module)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  cluster_name = "photoshare-eks"
  # ... many required vars: vpc_id, subnets, node_groups, etc.
}


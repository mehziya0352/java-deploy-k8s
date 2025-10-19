# -----------------------
# Get availability zones
# -----------------------
data "aws_availability_zones" "available" {}

# -----------------------
# VPC Module
# -----------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "regapp-vpc"
  cidr = "10.100.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  private_subnets = ["10.100.11.0/24", "10.100.12.0/24", "10.100.13.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# -----------------------
# EKS Cluster Module
# -----------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.4.0"

  name                 = var.cluster_name
  kubernetes_version   = "1.27"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnets

  eks_managed_node_groups = {
    regapp_nodes = {
      desired_size  = var.node_desired_capacity
      min_size      = var.node_min_capacity
      max_size      = var.node_max_capacity
      instance_types = [var.node_instance_type]

      tags = {
        Name = "${var.cluster_name}-node"
      }
    }
  }

  tags = {
    Project = "regapp"
  }
}


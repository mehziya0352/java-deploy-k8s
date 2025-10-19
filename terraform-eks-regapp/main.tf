module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0" # pick a compatible version; adjust if needed

  cluster_name    = var.cluster_name
  cluster_version = "1.27"   # or a K8s version supported in your region; change if needed
  subnets         = module.vpc.private_subnets

  # Create new VPC automatically
  vpc_id = module.vpc.vpc_id

  manage_aws_auth = true

  node_groups = {
    regapp_nodes = {
      desired_capacity = var.node_desired_capacity
      min_capacity     = var.node_min_capacity
      max_capacity     = var.node_max_capacity

      instance_types = [var.node_instance_type]

      # Optional - attach common tags
      tags = {
        Name = "${var.cluster_name}-node"
      }
    }
  }

  tags = {
    Project = "regapp"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name = "${var.cluster_name}-vpc"
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

data "aws_availability_zones" "available" {}

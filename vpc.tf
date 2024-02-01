provider "aws" {
  region = "us-east-1" 
}

data "aws_availability_zones" "azs" {}
module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.vpc_name
  cidr = var.vpc_cidr_block
  azs  = data.aws_availability_zones.azs.names
  
  private_subnets = var.private_subnets_cidr_block
  public_subnets  = var.public_subnets_cidr_block

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true


    tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        Terraform = "true"
        Environment = var.env_prefix
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        Terraform = "true"
        Environment = var.env_prefix
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        Terraform = "true"
        Environment = var.env_prefix
        "kubernetes.io/role/internal-elb" = 1
    }
}


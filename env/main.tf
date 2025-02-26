terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "../modules/vpc"
  name        = var.name
  cidr_block  = var.vpc_cidr
  azs         = var.azs
}

module "eks" {
  source             = "../modules/eks"
  name               = var.name
  private_subnet_ids = module.vpc.private_subnet_ids
  k8s_version        = var.k8s_version
}

output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

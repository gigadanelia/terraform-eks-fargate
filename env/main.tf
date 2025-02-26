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

# Comment out the VPC module
# module "vpc" {
#   source      = "../modules/vpc"
#   name        = var.name
#   cidr_block  = var.vpc_cidr
#   azs         = var.azs
# }

# Create a security group in the existing VPC
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Example security group"
  vpc_id      = "vpc-0ea0df6446e4d0488"  # Use the existing VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-security-group"
  }
}

# Comment out the EKS module
# module "eks" {
#   source             = "../modules/eks"
#   name               = var.name
#   private_subnet_ids = module.vpc.private_subnet_ids
#   k8s_version        = var.k8s_version
# }

# output "eks_endpoint" {
#   value = module.eks.cluster_endpoint
# }

# Output the security group ID
output "security_group_id" {
  value = aws_security_group.example_sg.id
}
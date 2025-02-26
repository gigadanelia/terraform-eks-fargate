variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "name" {
  type        = string
  description = "Name prefix for EKS resources"
  default     = "my-eks-fargate"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  # For Frankfurt region
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "k8s_version" {
  type    = string
  default = "1.24"
}

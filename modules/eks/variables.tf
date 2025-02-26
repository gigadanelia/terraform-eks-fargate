variable "name" {
  type        = string
  description = "EKS cluster name"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets where EKS is deployed"
}

variable "k8s_version" {
  type        = string
  default     = "1.24"
  description = "Kubernetes version for EKS"
}

# IAM role for EKS cluster
resource "aws_iam_role" "cluster_role" {
  name = "${var.name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_trust.json
}

data "aws_iam_policy_document" "cluster_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cluster_role_attach" {
  role       = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_service_attach" {
  role       = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Fargate execution role
resource "aws_iam_role" "fargate_pod_exec_role" {
  name = "${var.name}-fargate-pod-role"
  assume_role_policy = data.aws_iam_policy_document.fargate_trust.json
}

data "aws_iam_policy_document" "fargate_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "fargate_exec_attach" {
  role       = aws_iam_role.fargate_pod_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  # Minimal control plane logging
  enabled_cluster_log_types = ["api"]

  version = var.k8s_version

  depends_on = [
    aws_iam_role_policy_attachment.cluster_role_attach,
    aws_iam_role_policy_attachment.cluster_service_attach
  ]
}

resource "aws_eks_fargate_profile" "test_app" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.name}-test-app"
  pod_execution_role_arn = aws_iam_role.fargate_pod_exec_role.arn
  subnet_ids             = var.private_subnet_ids

  selector {
    namespace = "test-app"
  }

  depends_on = [aws_eks_cluster.this]
}

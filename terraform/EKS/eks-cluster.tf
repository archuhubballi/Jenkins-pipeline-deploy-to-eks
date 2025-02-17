provider "aws" {
  region = "us-east-2"  # Change to your AWS region
}

# Create IAM Role for the EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the EKS Cluster IAM Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# Create EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "simple-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["subnet-0902d6cf1abf54962", "subnet-055918a834bd0588c","subnet-056742b14f96d295d","subnet-0c48f86855dbd96a2"]  # Replace with your VPC subnet IDs
  }
}

# Security group for EKS
resource "aws_security_group" "eks_sec_group" {
  name        = "eks-sec-group"
  description = "EKS Security Group"
  vpc_id      = "vpc-086ecee9caad5aebd"  # Replace with your VPC ID

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define EKS Node Group (worker nodes)
resource "aws_eks_node_group" "example_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "dev-node-group"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn  # Use the same IAM role for the node group
  subnet_ids      = ["subnet-0902d6cf1abf54962", "subnet-055918a834bd0588c", "subnet-056742b14f96d295d", "subnet-0c48f86855dbd96a2"]  # Replace with your VPC subnet IDs

  scaling_config {
    desired_size = 1  # Set desired node count to 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.small"]

  ami_type = "ami-0cb91c7de36eed2cb"  
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

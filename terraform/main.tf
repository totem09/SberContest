provider "aws" {
  region = "us-east-1"
}

# Создание VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Создание Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Создание EKS кластера
resource "aws_eks_cluster" "k8s" {
  name     = "microservices-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.main.id]
  }
}

# Вывод kubeconfig
output "kubeconfig" {
  value = aws_eks_cluster.k8s.kubeconfig
}

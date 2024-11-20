provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "sbercontest-cluster"
  cluster_version = "1.25"
  subnets         = ["subnet-0123456789abcdef0"] # Замените на ваши подсети
  vpc_id          = "vpc-0123456789abcdef0"       # Замените на ваш VPC ID

  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t3.medium"
    }
  }
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

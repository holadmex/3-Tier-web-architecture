resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

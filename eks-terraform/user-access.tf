# Add your user access to EKS cluster
resource "aws_eks_access_entry" "admin_user" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = "arn:aws:iam::429841094792:user/Oladimeji"
  kubernetes_groups = []
  type             = "STANDARD"

  depends_on = [aws_eks_cluster.eks]
}

resource "aws_eks_access_policy_association" "admin_user_policy" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_eks_access_entry.admin_user.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin_user]
}
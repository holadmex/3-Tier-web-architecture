output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_ca_cert" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

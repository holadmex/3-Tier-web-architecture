# Force delete CloudWatch log group on destroy
resource "null_resource" "cleanup_logs" {
  triggers = {
    cluster_name = var.cluster_name
    region       = var.region
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws logs delete-log-group --log-group-name /aws/eks/${self.triggers.cluster_name}/cluster --region ${self.triggers.region} || true"
  }

  depends_on = [aws_eks_cluster.eks]
}
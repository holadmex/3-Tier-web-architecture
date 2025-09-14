# Minimal managed node group for Karpenter and system components
resource "aws_eks_node_group" "eks_nodes_1" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks-node-group-1"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.private[*].id
  
  instance_types = ["t2.medium"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ec2_container_registry,
  ]
  
  lifecycle {
    create_before_destroy = true
  }
  
  # Clean up controllers before destroying nodes
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "Cleaning up controllers before node group destruction..."
      
      # Delete Helm releases
      helm uninstall argocd -n argocd --ignore-not-found || true
      helm uninstall kube-prometheus-stack -n monitoring --ignore-not-found || true
      
      # Clean up load balancers
      kubectl get svc --all-namespaces -o json | jq -r '.items[] | select(.spec.type=="LoadBalancer") | "\(.metadata.namespace) \(.metadata.name)"' | while read ns name; do
        kubectl delete svc "$name" -n "$ns" --ignore-not-found=true || true
      done
      
      sleep 30
    EOT
  }

  tags = {
    Name = "${var.cluster_name}-node-group-1"
  }
}

# Key pair for node access (uncomment and add your public key if needed)
# resource "aws_key_pair" "eks_nodes" {
#   key_name   = "${var.cluster_name}-nodes"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7..." # Replace with your public key
# }

/*resource "aws_eks_node_group" "eks_nodes_2" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks-node-group-2"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}*/

# Ensure proper destroy order: Controllers -> Node Groups -> Cluster -> VPC
resource "null_resource" "controller_cleanup" {
  triggers = {
    cluster_name = aws_eks_cluster.eks.name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "Cleaning up controllers and workloads..."
      
      # Clean up any remaining load balancers
      kubectl get svc --all-namespaces -o json | jq -r '.items[] | select(.spec.type=="LoadBalancer") | "\(.metadata.namespace) \(.metadata.name)"' | while read ns name; do
        kubectl delete svc "$name" -n "$ns" --ignore-not-found=true || true
      done
      
      # Wait for cleanup
      sleep 30
    EOT
  }

  # Controllers must be destroyed before node groups
  depends_on = [
    helm_release.argocd,
    helm_release.kube_prometheus_stack
  ]
}

# Node groups depend on controller cleanup
resource "null_resource" "node_group_dependency" {
  depends_on = [
    null_resource.controller_cleanup
  ]
}
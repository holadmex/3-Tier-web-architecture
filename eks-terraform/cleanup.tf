# Ensure services are destroyed before VPC components
resource "null_resource" "service_cleanup" {
  triggers = {
    cluster_name = aws_eks_cluster.eks.name
    vpc_id       = aws_vpc.main.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "Cleaning up services before VPC destruction..."
      
      # Clean up any remaining ENIs
      aws ec2 describe-network-interfaces \
        --filters "Name=vpc-id,Values=${self.triggers.vpc_id}" \
        --query 'NetworkInterfaces[?Status==`available`].NetworkInterfaceId' \
        --output text | xargs -r -n1 aws ec2 delete-network-interface --network-interface-id || true
      
      # Wait for cleanup
      sleep 60
    EOT
  }

  # This resource depends on all services that use the cluster
  depends_on = [
    aws_db_instance.postgres,
    kubernetes_secret.database,
    kubernetes_namespace.dev
  ]
}
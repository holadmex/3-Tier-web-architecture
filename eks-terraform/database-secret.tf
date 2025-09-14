# Kubernetes secret for database connection in dev namespace
resource "kubernetes_secret" "database" {
  metadata {
    name      = "database-secret"
    namespace = "dev"
  }

  data = {
    DB_HOST     = aws_db_instance.postgres.endpoint
    DB_PORT     = "5432"
    DB_NAME     = aws_db_instance.postgres.db_name
    DB_USERNAME = aws_db_instance.postgres.username
    DB_PASSWORD = random_password.db_password.result
    DATABASE_URL = "postgresql://${aws_db_instance.postgres.username}:${random_password.db_password.result}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
  }

  type = "Opaque"
  
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks_nodes_1,
    aws_eks_access_entry.admin_user,
    kubernetes_namespace.dev
  ]
}

# Create dev namespace
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
  
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_access_entry.admin_user
  ]
}
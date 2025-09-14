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

output "backend_secrets_role_arn" {
  description = "IAM role ARN for backend service account to access Secrets Manager"
  value       = aws_iam_role.backend_secrets.arn
}

output "external_secrets_role_arn" {
  description = "IAM role ARN for External Secrets Operator"
  value       = aws_iam_role.external_secrets.arn
}

output "rds_secret_arn" {
  description = "AWS Secrets Manager secret ARN for RDS credentials"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "rds_secret_suffix" {
  description = "Random suffix for RDS secret name"
  value       = random_id.secret_suffix.hex
}

output "rds_secret_name" {
  description = "Full RDS secret name with suffix"
  value       = aws_secretsmanager_secret.rds_credentials.name
}

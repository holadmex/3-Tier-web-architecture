# Output the ECR Repository URL
output "ecr_repository_url" {
  value       = aws_ecr_repository.ecr.repository_url
  description = "The URL of the ECR repository"
}

# Output ECS Cluster Name
output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "The name of the ECS cluster"
}

# Output ECS Service Name
output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "The name of the ECS service"
}

# Output ECS Task Definition Name
output "ecs_task_definition_name" {
  value       = aws_ecs_task_definition.task.family
  description = "The name of the ECS task definition"
}

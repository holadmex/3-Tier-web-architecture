# ArgoCD
resource "helm_release" "argocd" {
  namespace        = "argocd"
  create_namespace = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.46.7"
  timeout          = 300

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
        resources = {
          requests = {
            memory = "256Mi"
            cpu    = "100m"
          }
          limits = {
            memory = "512Mi"
            cpu    = "200m"
          }
        }
      }
      controller = {
        resources = {
          requests = {
            memory = "512Mi"
            cpu    = "250m"
          }
          limits = {
            memory = "1Gi"
            cpu    = "500m"
          }
        }
      }
      repoServer = {
        resources = {
          requests = {
            memory = "256Mi"
            cpu    = "100m"
          }
          limits = {
            memory = "512Mi"
            cpu    = "200m"
          }
        }
      }
    })
  ]

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks_nodes_1,
    aws_eks_addon.coredns
  ]
}
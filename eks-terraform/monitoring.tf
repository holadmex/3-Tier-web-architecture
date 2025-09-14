# Prometheus and Grafana using kube-prometheus-stack
resource "helm_release" "kube_prometheus_stack" {
  namespace        = "monitoring"
  create_namespace = true
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "45.0.0"
  timeout          = 600
  wait             = false
  atomic           = false

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          retention = "7d"
          resources = {
            requests = {
              memory = "1Gi"
              cpu    = "500m"
            }
            limits = {
              memory = "2Gi"
              cpu    = "500m"
            }
          }
        }
      }
      grafana = {
        adminPassword = "admin123"
        service = {
          type = "LoadBalancer"
        }
        resources = {
          requests = {
            memory = "512Mi"
            cpu    = "200m"
          }
        }
      }
      alertmanager = {
        alertmanagerSpec = {
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
      }
    })
  ]

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks_nodes_1,
    aws_eks_addon.coredns
  ]
}
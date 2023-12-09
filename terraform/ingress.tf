# provider kubernetes {
#   config_path = "~/.kube/config"
#   config_context = "minikube"
# }



resource "kubernetes_ingress" "example" {
  wait_for_load_balancer = true
  metadata {
    name = "example"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = azurerm_kubernetes_cluster.aks_esgi.name
            service_port = 2345
          }
        }
      }
    }
  }
}

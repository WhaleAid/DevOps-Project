resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace  = "default"
  version    = "9.9.4"
  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.aks_public_ip.ip_address
  }
}


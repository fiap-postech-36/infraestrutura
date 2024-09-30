resource "kubernetes_service" "LoadBalancer" {
  metadata {
    name = "load-balancer-restaurant-api"
  }
  spec {
    selector = {
      name = "restaurant-api"
    }
    port {
      port        = 8080 # Porta externa exposta pelo Load Balancer
      target_port = 8080 # Porta em que sua aplicação está rodando no pod
    }
    type = "LoadBalancer"
  }
}

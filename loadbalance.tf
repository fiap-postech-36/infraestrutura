
resource "kubernetes_service" "load-balancer-restaurant-api" {
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
  depends_on = [aws_eks_cluster.cluster, aws_eks_node_group.node-1, aws_db_instance.postgres]
}

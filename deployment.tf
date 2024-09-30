resource "kubernetes_deployment" "restaurant-api" {
  metadata {
    name = "restaurant-api"
    labels = {
      name = "restaurant-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "restaurant-api"
      }
    }

    template {
      metadata {
        labels = {
          name = "restaurant-api"
        }
      }

      spec {
        container {
          image = "samuelmolendolff/api-restaurant:1.3.1-beta"
          name  = "api-restaurant-container"

          # Definindo parâmetros da JVM via variável de ambiente JAVA_OPTS
          env {
            name  = "JAVA_OPTS"
            value = "-Xms512m -Xmx512m -XX:+UseG1GC"
          }

          # Adicionando as variáveis de ambiente do ConfigMap
          env {
            name = "SPRING_DATASOURCE_URL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.restaurant-configmap.metadata[0].name
                key  = "SPRING_DATASOURCE_URL"
              }
            }
          }

          env {
            name = "SPRING_DATASOURCE_USERNAME"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.restaurant-configmap.metadata[0].name
                key  = "SPRING_DATASOURCE_USERNAME"
              }
            }
          }

          env {
            name = "SPRING_DATASOURCE_PASSWORD"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.restaurant-configmap.metadata[0].name
                key  = "SPRING_DATASOURCE_PASSWORD"
              }
            }
          }

          resources {
            requests = {
              memory = "600Mi"
              cpu    = "600m"
            }
            limits = {
              cpu    = "1000m"
              memory = "1000Mi"
            }
          }


          liveness_probe {
            http_get {
              path = "/restaurant/actuator/health/liveness"
              port = 8080
            }

            initial_delay_seconds = 50
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/restaurant/actuator/health/readiness"
              port = 8080
            }

            initial_delay_seconds = 50
            period_seconds        = 10
            failure_threshold     = 3
          }
        }
      }
    }
  }
  depends_on = [aws_eks_cluster.cluster, aws_eks_node_group.node-1, aws_db_instance.postgres]
}

resource "kubernetes_config_map" "restaurant-configmap" {
  metadata {
    name = "restaurant-configmap"
  }

  data = {
    SPRING_DATASOURCE_URL : "jdbc:postgresql://${aws_db_instance.postgres.endpoint}/${var.db_name}"
    SPRING_DATASOURCE_USERNAME : var.db_user
    SPRING_DATASOURCE_PASSWORD : var.db_password
  }

  depends_on = [aws_eks_cluster.cluster, aws_eks_node_group.node-1, aws_db_instance.postgres]
}

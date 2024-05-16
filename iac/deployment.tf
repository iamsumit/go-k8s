resource "kubernetes_deployment" "gok8s" {
  provider = kubernetes

  metadata {
    name = "gok8s"
    namespace = "${kubernetes_namespace.gok8s.metadata.0.name}"

    labels = {
      app = "gok8s"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "gok8s"
      }
    }

    template {
      metadata {
        labels = {
          app = "gok8s"
        }
      }

      spec {
        container {
          image = "${var.image}"
          name  = "gok8s"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 8080
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 8080
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.gok8s
  ]
}
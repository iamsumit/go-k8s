resource "kubernetes_service" "gok8s" {
  provider = kubernetes

  metadata {
    name = "gok8s"
    namespace = "${kubernetes_namespace.gok8s.metadata.0.name}"

    labels = {
      app = "gok8s"
    }
  }

  spec {
    selector = {
      app = "gok8s"
    }

    port {
      port        = 80
      target_port = 8080
      protocol = "TCP"
    }
  }

  depends_on = [
    kubernetes_deployment.gok8s
  ]
}

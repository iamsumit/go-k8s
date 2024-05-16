provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "${var.context_name}"
}

resource "kubernetes_namespace" "gok8s" {
  provider = kubernetes

  metadata {
    name = "gok8s"
  }
}

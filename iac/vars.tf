variable "context_name" {
  description = "The name of the Kubernetes context to use"
  default    = "minikube"
}

variable "image" {
  description = "The Docker image to use for the deployment"
  default     = "ttl.sh/iamsumit/svc1:gok8s"  
}

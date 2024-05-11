.ONESHELL:

IMAGE_NAME := iamsumit/go-k8s:v1
K8S_MANIFEST := ./k8s/goapp.yaml
K8S_METRICS_SERVER := ./k8s/metrics-server.yaml
K8S_INGRESS := ./k8s/goapp-ingress-cert.yaml

.PHONY: all build push deploy clean start

all: build push deploy

build:
	docker build -t $(IMAGE_NAME) .

deploy:
	minikube addons enable metrics-server
	minikube addons enable ingress
	kubectl apply -f ${K8S_METRICS_SERVER}
	kubectl apply -f $(K8S_MANIFEST)
	# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=go-k8s.local"
	# kubectl create secret tls go-k8s-openssl --cert=tls.crt --key=tls.key
	kubectl apply -f $(K8S_INGRESS)

clean:
	kubectl delete -f $(K8S_INGRESS)
	kubectl delete -f $(K8S_MANIFEST)
	kubectl delete -f ${K8S_METRICS_SERVER}
	docker rmi -f $(IMAGE_NAME)

start:
	minikube service -n go-k8s go-k8s

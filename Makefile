.ONESHELL:

IMAGE_NAME := iamsumit/go-k8s:v1
K8S_MANIFEST := ./k8s/goapp.yaml
K8S_METRICS_SERVER := ./k8s/metrics-server.yaml

.PHONY: all build push deploy clean start

all: build push deploy

build:
	docker build -t $(IMAGE_NAME) .

deploy:
	minikube addons enable metrics-server
	kubectl apply -f ${K8S_METRICS_SERVER}
	kubectl apply -f $(K8S_MANIFEST)

	# Or we can do this way as well.
	# kubectl create namespace go-k8s
	# kubectl create deployment go-k8s --image=$(IMAGE_NAME)
	# kubectl expose deployment go-k8s --type=NodePort --port=80 --target=8080

clean:
	docker rmi -f $(IMAGE_NAME)
	kubectl delete -f $(K8S_MANIFEST)
	kubectl delete -f ${K8S_METRICS_SERVER}

	# Or we can do this way as well.
	# kubectl delete namespace go-k8s
	# kubectl delete deployment go-k8s
	# kubectl delete service go-k8s

start:
	minikube service -n go-k8s go-k8s

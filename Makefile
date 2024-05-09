.ONESHELL:

IMAGE_NAME := iamsumit/go-k8s:v1
K8S_DEPLOYMENT := ./k8s/deployment.yaml
K8S_SERVICE := ./k8s/service.yaml

.PHONY: all build push deploy clean start

all: build push deploy

build:
	docker build -t $(IMAGE_NAME) .

deploy:
	kubectl apply -f $(K8S_DEPLOYMENT)
	kubectl apply -f $(K8S_SERVICE)

	# Or we can do this way as well.
	# kubectl create deployment go-k8s --image=$(IMAGE_NAME)
	# kubectl expose deployment go-k8s --type=NodePort --port=8080

clean:
	docker rmi -f $(IMAGE_NAME)
	kubectl delete -f $(K8S_DEPLOYMENT)
	kubectl delete -f $(K8S_SERVICE)

	# Or we can do this way as well.
	# kubectl delete deployment go-k8s
	# kubectl delete service go-k8s

start:
	minikube service go-k8s

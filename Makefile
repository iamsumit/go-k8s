IMAGE_NAME := sumitpantheon/go-k8s
K8S_DEPLOYMENT := ./k8s/deployment.yaml
K8S_SERVICE := ./k8s/service.yaml

.PHONY: all build push deploy clean start

all: init build push deploy

init:
	minikube start

build:
	docker build -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)

deploy:
	kubectl apply -f $(K8S_DEPLOYMENT)
	kubectl apply -f $(K8S_SERVICE)

clean:
	docker rmi $(IMAGE_NAME)
	kubectl delete -f $(K8S_DEPLOYMENT)
	kubectl delete -f $(K8S_SERVICE)

start:
	minikube service go-k8s

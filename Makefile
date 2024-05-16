SVC1_DIR := ./service/svc1
SVC1_IMAGE := ttl.sh/iamsumit/svc1:go-k8s

SVC2_DIR := ./service/svc2
SVC2_IMAGE := ttl.sh/iamsumit/svc2:go-k8s

MANIFEST_DIR := ./manifest

svc1-build:
		@echo "Building Docker image..."
		cd $(SVC1_DIR) && docker build -t ${SVC1_IMAGE} .

		@echo "Pushing Docker image..."
		docker push ${SVC1_IMAGE}

svc2-build:
		@echo "Building Docker image..."
		cd $(SVC2_DIR) && docker build -t ${SVC2_IMAGE} .

		@echo "Pushing Docker image..."
		docker push ${SVC2_IMAGE}

build:
	make svc1-build
	make svc2-build

diff:
		@echo "Checking differences..."
		kubectl diff -f $(MANIFEST_DIR)

deploy:
		@echo "Applying differences..."
		kubectl apply -f $(MANIFEST_DIR)

clean:
		@echo "Deleting resources..."
		kubectl delete -f $(MANIFEST_DIR)

start:
		@echo "Starting services..."
		minikube service -n go-k8s svc2

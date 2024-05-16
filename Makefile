SVC1_DIR := ./service/svc1
IMAGE := ttl.sh/iamsumit/svc1:gok8s
TERRAFORM_DIR := ./manifest

build:
		@echo "Building Docker image..."
		cd $(SVC1_DIR) && docker build -t ${IMAGE} .

		@echo "Pushing Docker image..."
		docker push ${IMAGE}

diff:
		@echo "Initializing Terraform..."
		cd $(TERRAFORM_DIR) && terraform init

		@echo "Checking Terraform changes..."
		cd $(TERRAFORM_DIR) && terraform plan

deploy:
		@echo "Initializing Terraform..."
		cd $(TERRAFORM_DIR) && terraform init

		@echo "Applying Terraform changes..."
		cd $(TERRAFORM_DIR) && terraform apply

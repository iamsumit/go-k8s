# go-k8s

Run following commands to see it in working locally:

```
minikube start
eval $(minikube docker-env)

// Build and deploy
make build
make deploy

# Give it couple of seconds and start the service.
make start

# Cleanup image and k8s deployments.
make clean
```

# go-k8s

This repository is for my learning purpose only, big thanks to the [Kubernetes 101](https://www.youtube.com/playlist?list=PL2_OBreMn7FoYmfx27iSwocotjiikS5BD) by Jeff Geerling.

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

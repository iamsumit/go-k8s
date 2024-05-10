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

# Verify the logs in kubectl with three replicas running.
kubectl logs -f -l app=go-k8s --prefix=true

# Cleanup image and k8s deployments.
make clean

# To update the image in existing deployment.
kubectl set image deployment/go-k8s go-k8s=iamsumit/go-k8s:v2

# To check the deployment history
kubectl rollout history deployment go-k8s

# To rollback to last version.
kubectl rollout undo deployment go-k8s

# For benchmark testing
ab -n 5000 -c 50 http://127.0.0.1:51270/hello
```

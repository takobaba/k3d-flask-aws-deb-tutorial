# Kubernetes Flask App Deployment Guide

This guide provides step-by-step instructions to deploy the Flask app to a k3d Kubernetes cluster.

## Prerequisites

- Fresh Debian 12 VM or Ubuntu instance
- Docker, kubectl, and k3d installed (see setup script)
- Git installed
- Internet connection

## Step 1: Clone Repository and Setup Environment

```bash
# Clone the repository
git clone <your-repo-url>
cd kubernetes-flask-tutorial

# Run setup script (if tools not installed)
chmod +x scripts/setup-debian.sh
./scripts/setup-debian.sh

# Refresh Docker permissions
newgrp docker
```

## Step 2: Verify Prerequisites

```bash
# Verify all tools are installed
docker --version
kubectl version --client
k3d version
python3 --version
```

## Step 3: Test Flask App Locally (Optional)

```bash
# Navigate to app directory
cd app

# Install dependencies
pip3 install -r requirements.txt

# Test the app
python3 app.py &
curl http://localhost:8080        # Should return: amazon
curl http://localhost:8080/healthcheck  # Should return: OK
kill %1  # Stop the app
cd ..
```

## Step 4: Build Docker Image

```bash
# Build the Flask app container
cd app
docker build -t flask-app:latest .

# Verify image was created
docker images | grep flask-app
cd ..
```

## Step 5: Create k3d Kubernetes Cluster

```bash
# Create k3d cluster
k3d cluster create mycluster

# Verify cluster is running
k3d cluster list
kubectl get nodes
```

## Step 6: Import Docker Image to k3d

```bash
# Import local image to k3d cluster
k3d image import flask-app:latest --cluster mycluster

# Verify image is in cluster
docker exec k3d-mycluster-server-0 crictl images | grep flask-app
```

## Step 7: Deploy to Kubernetes

```bash
# Deploy the application
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

# Check deployment status
kubectl get pods
kubectl get services
```

## Step 8: Wait for Pods to be Ready

```bash
# Watch pods until they're running
kubectl get pods -w

# You should see:
# NAME                         READY   STATUS    RESTARTS   AGE
# flask-app-xxxxxxxxxx-xxxxx   1/1     Running   0          30s
# flask-app-xxxxxxxxxx-xxxxx   1/1     Running   0          30s

# Press Ctrl+C to stop watching
```

## Step 9: Test the Deployment

```bash
# Port forward to access the service
kubectl port-forward service/flask-service 8081:80 &

# Test the endpoints
curl http://localhost:8081        # Should return: amazon
curl http://localhost:8081/healthcheck  # Should return: OK

# Stop port forwarding
kill %1
```

## Step 10: Verify Load Balancing

```bash
# Check pod details
kubectl get pods -o wide

# Check logs from different pods
kubectl logs <pod-name-1>
kubectl logs <pod-name-2>

# Test multiple requests to see load balancing
kubectl port-forward service/flask-service 8081:80 &
for i in {1..10}; do curl http://localhost:8081; echo; done
kill %1
```

## Troubleshooting

### If pods show ImagePullBackOff:
```bash
# Check if image import worked
docker exec k3d-mycluster-server-0 crictl images | grep flask-app

# If not found, re-import
k3d image import flask-app:latest --cluster mycluster

# Restart deployment
kubectl rollout restart deployment flask-app
```

### If port 8081 is busy:
```bash
# Use a different port
kubectl port-forward service/flask-service 8082:80
curl http://localhost:8082
```

### If cluster doesn't start:
```bash
# Delete and recreate cluster
k3d cluster delete mycluster
k3d cluster create mycluster
```

## Cleanup

When you're done testing:

```bash
# Delete Kubernetes resources
kubectl delete -f kubernetes/

# Delete k3d cluster
k3d cluster delete mycluster

# Remove Docker image
docker rmi flask-app:latest
```

## Success Criteria

✅ 2 pods running with status "Running"  
✅ Service accessible via port-forward  
✅ Main endpoint returns "amazon"  
✅ Health check endpoint returns "OK"  
✅ Load balancing between 2 replicas working  

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Your Client   │───▶│  flask-service   │───▶│   flask-app     │
│  (port 8081)    │    │   (NodePort)     │    │   (2 replicas)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌──────────────────┐
                       │   k3d cluster    │
                       │  (mycluster)     │
                       └──────────────────┘
```

Your Flask app is now running in a production-ready Kubernetes environment! 🚀

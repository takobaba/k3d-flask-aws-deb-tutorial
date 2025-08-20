#!/bin/bash
set -e
echo "🚀 Starting Kubernetes Flask App Deployment..."
cd app
docker build -t flask-app:latest .
cd ..
k3d cluster create mycluster || echo "Cluster might already exist"
k3d image import flask-app:latest --cluster mycluster
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl wait --for=condition=ready pod -l app=flask-app --timeout=60s
echo "✅ Deployment complete!"
kubectl get pods -o wide
kubectl get services

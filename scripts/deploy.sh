#!/bin/bash
set -e
echo "🚀 Starting Kubernetes Flask App Deployment..."
echo "📦 Building Docker image..."
cd app
docker build -t flask-app:latest .
cd ..
echo "🔧 Creating k3d cluster..."
k3d cluster create mycluster || echo "Cluster might already exist"
echo "📥 Importing image to k3d..."
k3d image import flask-app:latest --cluster mycluster
echo "🚢 Deploying to Kubernetes..."
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=flask-app --timeout=60s
echo "✅ Deployment complete!"
kubectl get pods -o wide
kubectl get services
echo "🧪 Test: kubectl port-forward service/flask-service 8081:80 &"

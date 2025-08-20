#!/bin/bash
echo "🧹 Cleaning up..."
kubectl delete -f kubernetes/ || echo "Resources might not exist"
k3d cluster delete mycluster || echo "Cluster might not exist"
docker rmi flask-app:latest || echo "Image might not exist"
echo "✅ Cleanup complete!"

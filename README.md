# Kubernetes Flask App Tutorial

A complete tutorial for deploying a Flask HTTP server to Kubernetes using k3d.

## Quick Start

**For step-by-step deployment instructions, see [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md)**

**For automated deployment:**
```bash
git clone <your-repo-url>
cd kubernetes-flask-tutorial
./scripts/setup-debian.sh  # Install prerequisites
newgrp docker              # Refresh permissions
./scripts/deploy.sh         # Deploy everything
```

## What This Tutorial Covers

- ✅ Flask HTTP server returning "amazon" and health check
- ✅ Docker containerization with proper Dockerfile
- ✅ Kubernetes deployment with 2 replicas
- ✅ Load balancing with NodePort service
- ✅ Local development and testing
- ✅ Production-ready k3d cluster setup

## Project Structure

```
kubernetes-flask-tutorial/
├── README.md                    # This file
├── DEPLOYMENT-GUIDE.md          # Step-by-step instructions
├── app/
│   ├── app.py                   # Flask HTTP server
│   ├── requirements.txt         # Python dependencies
│   └── Dockerfile              # Container definition
├── kubernetes/
│   ├── deployment.yaml          # Kubernetes deployment
│   └── service.yaml            # Kubernetes service
└── scripts/
    ├── setup-debian.sh         # Install prerequisites
    ├── deploy.sh               # Automated deployment
    ├── cleanup.sh              # Clean up resources
    └── debian-ssm-userdata.sh  # User data for Debian EC2 instances
```

## Prerequisites

- Debian 12 or Ubuntu VM/instance
- Internet connection
- Basic terminal knowledge

**For AWS EC2 Debian instances:** Use `scripts/debian-ssm-userdata.sh` as user data to install SSM Agent for Session Manager access.

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

## Testing

Once deployed, test your Flask app:

```bash
# Port forward to access the service
kubectl port-forward service/flask-service 8081:80 &

# Test endpoints
curl http://localhost:8081        # Returns: amazon
curl http://localhost:8081/healthcheck  # Returns: OK

# Stop port forwarding
kill %1
```

## Key Features Demonstrated

1. **Container Best Practices**: Multi-stage builds, non-root user, minimal base image
2. **Kubernetes Patterns**: Deployments, services, health checks, environment variables
3. **Local Development**: k3d for local Kubernetes testing
4. **Image Management**: Local image import to avoid registry dependencies
5. **Load Balancing**: Multiple replicas with service discovery

## Troubleshooting

See [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md) for detailed troubleshooting steps.

Common issues:
- **ImagePullBackOff**: Ensure `k3d image import` completed successfully
- **Port conflicts**: Use different ports for port-forward
- **Permission errors**: Run `newgrp docker` after setup

## Cleanup

```bash
./scripts/cleanup.sh
```

## Success Criteria

✅ Flask app responds with "amazon" on `/`  
✅ Health check responds with "OK" on `/healthcheck`  
✅ 2 pods running and load-balanced  
✅ Service accessible via port-forward  

Your Flask app is now running in a production-ready Kubernetes environment! 🚀

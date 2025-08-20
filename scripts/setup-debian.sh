#!/bin/bash
echo "Installing Docker..."
sudo apt update
sudo apt install -y docker.io git python3 python3-pip
sudo usermod -aG docker $USER
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "Setup complete! Run newgrp docker to refresh permissions."

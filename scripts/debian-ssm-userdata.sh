#!/bin/bash
# User Data Script for Debian 12 EC2 Instances
apt-get update -y
apt-get install -y curl wget
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

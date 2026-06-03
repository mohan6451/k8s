#!/bin/bash

sudo apt update
sudo apt upgrade -y

#for installing eksctl
curl -sLO "https://github.com"
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_arm64.tar.gz"
tar -xzf eksctl_Linux_*.tar.gz -C /tmp && rm eksctl_Linux_*.tar.gz
sudo mv /tmp/eksctl /usr/local/bin




#for installing kubectl 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

# to install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version

#install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify
helm version


# " aws sts get-caller-identity " - to Verify IAM Role is being picked or not. 










# aws eks describe-nodegroup \
#   --cluster-name cluster1 \
#   --nodegroup-name cluster1 \
#   --region us-east-1 \
#   --query 'nodegroup.health'

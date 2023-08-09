#!/bin/bash

# install kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x kind 
./kind create cluster

# install crossplane on kind
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace

# aliases
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kgp='kubectl get pods'
alias kn='kubectl config set-context --current --namespace'

# deploy provider
kubectl apply -f provider.yaml 
kubectl apply -f providerconfig.yaml 

# create secret
cat > secret.yaml <<-EOF
[default]
aws_access_key_id = access-key-id
aws_secret_access_key = secret-access-key
EOF
kubectl create secret generic aws-secret --from-file creds=./secret.yaml -n crossplane-system

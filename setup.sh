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
alias kn='kubectl config set-context --current --namespace'

# deploy provider
kubectl apply -f provider.yaml 
kubectl apply -f providerconfig.yaml 

# create secret
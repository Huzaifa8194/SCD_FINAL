#!/bin/bash

# Script to manually deploy to Minikube
# This script can be used to test the deployment before setting up GitHub Actions

# Set variables
DOCKER_USERNAME="huzaifa8195"
IMAGE_NAME="vehicle-frontend"
TAG="latest"
NAMESPACE="vehicle-app"

echo "Starting Minikube deployment process..."

# Check if Minikube is running
if ! minikube status | grep -q "host: Running"; then
  echo "Minikube is not running. Starting Minikube..."
  minikube start
fi

# Configure Docker to use Minikube's daemon
echo "Configuring Docker to use Minikube's daemon..."
eval $(minikube docker-env)

# Build the Docker image
echo "Building Docker image..."
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$TAG ../

# Create namespace if it doesn't exist
echo "Creating namespace if it doesn't exist..."
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."

# Apply ConfigMap first
kubectl apply -f ../k8s/frontend-config.yaml -n $NAMESPACE

# Apply PVC
kubectl apply -f ../k8s/data-pvc.yaml -n $NAMESPACE

# Update namespace in deployment file
sed -i 's/namespace: default/namespace: '$NAMESPACE'/g' ../k8s/frontend-deployment-new.yaml

# Apply Deployment
kubectl apply -f ../k8s/frontend-deployment-new.yaml -n $NAMESPACE

# Apply Service
kubectl apply -f ../k8s/frontend-service.yaml

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/frontend -n $NAMESPACE

# Display deployment information
echo "=== Pods ==="
kubectl get pods -n $NAMESPACE

echo "=== Services ==="
kubectl get services -n $NAMESPACE

echo "=== Deployments ==="
kubectl get deployments -n $NAMESPACE

# Access the application
echo "To access the application, run the following command:"
echo "minikube service frontend -n $NAMESPACE"
minikube service frontend -n $NAMESPACE --url 
#!/bin/bash

# Create persistent volume claims
echo "Creating persistent volume claims..."
kubectl apply -f mongodb/mongodb-pvc.yaml
kubectl apply -f data-pvc.yaml

# Wait for PVCs to be bound
echo "Waiting for PVCs to be bound..."
echo "This may take a while. If it times out, run the fix-storage.sh script."
kubectl wait --for=condition=bound pvc/mongodb-pvc --timeout=120s
kubectl wait --for=condition=bound pvc/data-pvc --timeout=120s

# Deploy MongoDB
echo "Deploying MongoDB..."
kubectl apply -f mongodb/mongodb-deployment.yaml
kubectl apply -f mongodb/mongodb-service.yaml

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=available deployment/mongodb --timeout=180s

# Deploy Backend
echo "Deploying Backend..."
kubectl apply -f backend/backend-config.yaml
kubectl apply -f backend/backend-deployment.yaml
kubectl apply -f backend/backend-service.yaml

# Wait for Backend to be ready
echo "Waiting for Backend to be ready..."
kubectl wait --for=condition=available deployment/backend --timeout=180s

# Deploy Frontend
echo "Deploying Frontend..."
kubectl apply -f frontend/frontend-deployment.yaml
kubectl apply -f frontend/frontend-service.yaml

echo "Deployment complete!"
echo "You can access the frontend at: $(minikube ip):30080" 
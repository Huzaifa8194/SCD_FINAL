#!/bin/bash

# Check current StorageClass
echo "Checking current StorageClass..."
kubectl get storageclass

# Enable the default storage provisioner in Minikube
echo -e "\nEnabling default storage provisioner in Minikube..."
minikube addons enable storage-provisioner
minikube addons enable default-storageclass

# Wait for the storage provisioner to be ready
echo -e "\nWaiting for storage provisioner to be ready..."
sleep 10

# Check StorageClass again
echo -e "\nChecking StorageClass after enabling addons..."
kubectl get storageclass

# Delete existing PVCs
echo -e "\nDeleting existing PVCs..."
kubectl delete pvc mongodb-pvc data-pvc

# Apply PVCs again
echo -e "\nCreating PVCs again..."
kubectl apply -f mongodb/mongodb-pvc.yaml
kubectl apply -f data-pvc.yaml

# Check PVC status
echo -e "\nChecking PVC status..."
kubectl get pvc

echo -e "\nStorage setup complete! You can now run deploy.sh again." 
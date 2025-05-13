#!/bin/bash

echo "Cleaning up Kubernetes resources..."

echo "Deleting frontend resources..."
kubectl delete -f frontend/

echo "Deleting backend resources..."
kubectl delete -f backend/

echo "Deleting MongoDB resources..."
kubectl delete -f mongodb/

echo "Deleting shared PVC..."
kubectl delete -f data-pvc.yaml

echo "Cleanup complete!" 
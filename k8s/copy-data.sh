#!/bin/bash

# Get the backend pod name
BACKEND_POD=$(kubectl get pods -l app=backend -o jsonpath="{.items[0].metadata.name}")

# Create data directory in the pod if it doesn't exist
echo "Creating data directory in the pod..."
kubectl exec $BACKEND_POD -- mkdir -p /app/data

# Copy JSON files to the pod
echo "Copying JSON files to the pod..."
kubectl cp ../data/result.json $BACKEND_POD:/app/data/result.json
kubectl cp ../data/ocrresult.json $BACKEND_POD:/app/data/ocrresult.json

# Create images directory if it doesn't exist
echo "Creating images directory in the pod..."
kubectl exec $BACKEND_POD -- mkdir -p /app/data/downloaded_images

# Copy image files if they exist
if [ -d "../data/downloaded_images" ]; then
  echo "Copying image files to the pod..."
  for file in ../data/downloaded_images/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      kubectl cp "$file" $BACKEND_POD:/app/data/downloaded_images/$filename
    fi
  done
else
  echo "No images directory found at ../data/downloaded_images"
fi

echo "Data copy complete!" 
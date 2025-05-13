#!/bin/bash

# Set your Docker Hub username
DOCKER_USERNAME="huzaifa8195"

# Build and push the backend image
echo "Building and pushing backend image..."
cd ../backend
docker build -t $DOCKER_USERNAME/vehicle-backend:latest .
docker push $DOCKER_USERNAME/vehicle-backend:latest

# Build and push the frontend image
echo "Building and pushing frontend image..."
cd ..
docker build -t $DOCKER_USERNAME/vehicle-frontend:latest .
docker push $DOCKER_USERNAME/vehicle-frontend:latest

echo "Done!" 
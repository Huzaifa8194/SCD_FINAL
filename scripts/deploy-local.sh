#!/bin/bash

# Script to pull the latest Docker image and deploy locally
# This script should be executed after a new image is pushed to Docker Hub

# Set variables
DOCKER_USERNAME="huzaifa8195"
IMAGE_NAME="vehicle-frontend"
TAG="latest"

echo "Starting local deployment process..."

# Pull the latest image
echo "Pulling the latest image from Docker Hub..."
docker pull $DOCKER_USERNAME/$IMAGE_NAME:$TAG

# Stop and remove the existing container if it exists
echo "Stopping existing container if running..."
docker stop $IMAGE_NAME 2>/dev/null || true
docker rm $IMAGE_NAME 2>/dev/null || true

# Run the new container
echo "Starting new container..."
docker run -d --name $IMAGE_NAME -p 80:80 $DOCKER_USERNAME/$IMAGE_NAME:$TAG

echo "Deployment completed successfully!"
echo "Application is now running at http://localhost" 
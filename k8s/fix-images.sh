#!/bin/bash

# Script to replace ${DOCKER_USERNAME} placeholder with actual Docker username in deployment files

# Check if Docker username is provided as an argument
if [ $# -eq 0 ]; then
    echo "Please enter your Docker Hub username:"
    read DOCKER_USERNAME
else
    DOCKER_USERNAME=$1
fi

# Validate Docker username
if [ -z "$DOCKER_USERNAME" ]; then
    echo "Error: Docker username cannot be empty"
    exit 1
fi

echo "Replacing \${DOCKER_USERNAME} with $DOCKER_USERNAME in deployment files..."

# Find all YAML files in the k8s directory and replace the placeholder
find . -name "*.yaml" -type f -exec sed -i "s/\${DOCKER_USERNAME}/$DOCKER_USERNAME/g" {} \;

echo "Image names updated successfully!"
echo "You can now build and push your Docker images with:"
echo "./build-push.sh" 
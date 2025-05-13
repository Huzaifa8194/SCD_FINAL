#!/bin/bash

# Get the backend pod name
BACKEND_POD=$(kubectl get pods -l app=backend -o jsonpath="{.items[0].metadata.name}")

# Run the init-db script in the backend pod
echo "Initializing database..."
kubectl exec $BACKEND_POD -- npm run init-db

echo "Database initialization complete!" 
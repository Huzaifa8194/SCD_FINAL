# Create persistent volume claims
Write-Host "Creating persistent volume claims..."
kubectl apply -f mongodb/mongodb-pvc.yaml
kubectl apply -f data-pvc.yaml

# Wait for PVCs to be bound
Write-Host "Waiting for PVCs to be bound..."
Write-Host "This may take a while. If it times out, run the fix-storage.ps1 script."
kubectl wait --for=condition=bound pvc/mongodb-pvc --timeout=120s
kubectl wait --for=condition=bound pvc/data-pvc --timeout=120s

# Deploy MongoDB
Write-Host "Deploying MongoDB..."
kubectl apply -f mongodb/mongodb-deployment.yaml
kubectl apply -f mongodb/mongodb-service.yaml

# Wait for MongoDB to be ready
Write-Host "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=available deployment/mongodb --timeout=180s

# Deploy Backend
Write-Host "Deploying Backend..."
kubectl apply -f backend/backend-config.yaml
kubectl apply -f backend/backend-deployment.yaml
kubectl apply -f backend/backend-service.yaml

# Wait for Backend to be ready
Write-Host "Waiting for Backend to be ready..."
kubectl wait --for=condition=available deployment/backend --timeout=180s

# Deploy Frontend
Write-Host "Deploying Frontend..."
kubectl apply -f frontend/frontend-deployment.yaml
kubectl apply -f frontend/frontend-service.yaml

Write-Host "Deployment complete!"
Write-Host "You can access the frontend at: $(minikube ip):30080" 
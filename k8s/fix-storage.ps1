# Check current StorageClass
Write-Host "Checking current StorageClass..." -ForegroundColor Cyan
kubectl get storageclass

# Enable the default storage provisioner in Minikube
Write-Host "`nEnabling default storage provisioner in Minikube..." -ForegroundColor Cyan
minikube addons enable storage-provisioner
minikube addons enable default-storageclass

# Wait for the storage provisioner to be ready
Write-Host "`nWaiting for storage provisioner to be ready..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# Check StorageClass again
Write-Host "`nChecking StorageClass after enabling addons..." -ForegroundColor Cyan
kubectl get storageclass

# Delete existing PVCs
Write-Host "`nDeleting existing PVCs..." -ForegroundColor Yellow
kubectl delete pvc mongodb-pvc data-pvc

# Apply PVCs again
Write-Host "`nCreating PVCs again..." -ForegroundColor Green
kubectl apply -f mongodb/mongodb-pvc.yaml
kubectl apply -f data-pvc.yaml

# Check PVC status
Write-Host "`nChecking PVC status..." -ForegroundColor Cyan
kubectl get pvc

Write-Host "`nStorage setup complete! You can now run deploy.ps1 again." -ForegroundColor Green 
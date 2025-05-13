Write-Host "Cleaning up Kubernetes resources..." -ForegroundColor Cyan

Write-Host "Deleting frontend resources..." -ForegroundColor Yellow
kubectl delete -f frontend/

Write-Host "Deleting backend resources..." -ForegroundColor Yellow
kubectl delete -f backend/

Write-Host "Deleting MongoDB resources..." -ForegroundColor Yellow
kubectl delete -f mongodb/

Write-Host "Deleting shared PVC..." -ForegroundColor Yellow
kubectl delete -f data-pvc.yaml

Write-Host "Cleanup complete!" -ForegroundColor Green 
Write-Host "=== Checking Persistent Volume Claims ===" -ForegroundColor Cyan
kubectl get pvc

Write-Host "`n=== Checking Pods ===" -ForegroundColor Cyan
kubectl get pods

Write-Host "`n=== Checking Services ===" -ForegroundColor Cyan
kubectl get svc

Write-Host "`n=== Checking Deployments ===" -ForegroundColor Cyan
kubectl get deployments

Write-Host "`n=== Frontend URL ===" -ForegroundColor Cyan
$ip = minikube ip
Write-Host "http://$ip`:30080" 
# PowerShell script to manually deploy to Minikube
# This script can be used to test the deployment before setting up GitHub Actions

# Set variables
$DOCKER_USERNAME = "huzaifa8195"
$IMAGE_NAME = "vehicle-frontend"
$TAG = "latest"
$NAMESPACE = "vehicle-app"

Write-Host "Starting Minikube deployment process..."

# Check if Minikube is running
$minikubeStatus = minikube status
if (-not ($minikubeStatus -match "host: Running")) {
    Write-Host "Minikube is not running. Starting Minikube..."
    minikube start
}

# Configure Docker to use Minikube's daemon
Write-Host "Configuring Docker to use Minikube's daemon..."
minikube docker-env | Invoke-Expression

# Build the Docker image
Write-Host "Building Docker image..."
docker build -t $DOCKER_USERNAME/$IMAGE_NAME`:$TAG ..

# Create namespace if it doesn't exist
Write-Host "Creating namespace if it doesn't exist..."
kubectl get namespace $NAMESPACE 2>$null
if ($LASTEXITCODE -ne 0) {
    kubectl create namespace $NAMESPACE
}

# Apply Kubernetes manifests
Write-Host "Applying Kubernetes manifests..."

# Apply ConfigMap first
kubectl apply -f ..\k8s\frontend-config.yaml -n $NAMESPACE

# Apply PVC
kubectl apply -f ..\k8s\data-pvc.yaml -n $NAMESPACE

# Update namespace in deployment file
(Get-Content ..\k8s\frontend-deployment-new.yaml) -replace 'namespace: default', "namespace: $NAMESPACE" | Set-Content ..\k8s\frontend-deployment-new.yaml

# Apply Deployment
kubectl apply -f ..\k8s\frontend-deployment-new.yaml -n $NAMESPACE

# Apply Service
kubectl apply -f ..\k8s\frontend-service.yaml

# Wait for deployment to be ready
Write-Host "Waiting for deployment to be ready..."
kubectl rollout status deployment/frontend -n $NAMESPACE

# Display deployment information
Write-Host "=== Pods ===" -ForegroundColor Cyan
kubectl get pods -n $NAMESPACE

Write-Host "=== Services ===" -ForegroundColor Cyan
kubectl get services -n $NAMESPACE

Write-Host "=== Deployments ===" -ForegroundColor Cyan
kubectl get deployments -n $NAMESPACE

# Access the application
Write-Host "To access the application, run the following command:" -ForegroundColor Green
Write-Host "minikube service frontend -n $NAMESPACE" -ForegroundColor Yellow
$serviceUrl = minikube service frontend -n $NAMESPACE --url
Write-Host "Service URL: $serviceUrl" -ForegroundColor Green 
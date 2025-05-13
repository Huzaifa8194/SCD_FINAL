# Set your Docker Hub username
$DOCKER_USERNAME = "huzaifa8195"

# Build and push the backend image
Write-Host "Building and pushing backend image..."
Set-Location -Path ..\backend
docker build -t "$($DOCKER_USERNAME)/vehicle-backend:latest" .
docker push "$($DOCKER_USERNAME)/vehicle-backend:latest"

# Build and push the frontend image
Write-Host "Building and pushing frontend image..."
Set-Location -Path ..
docker build -t "$($DOCKER_USERNAME)/vehicle-frontend:latest" .
docker push "$($DOCKER_USERNAME)/vehicle-frontend:latest"

Write-Host "Done!" 
# PowerShell script to replace ${DOCKER_USERNAME} placeholder with actual Docker username in deployment files

# Check if Docker username is provided as an argument
if ($args.Count -eq 0) {
    Write-Host "Please enter your Docker Hub username:" -ForegroundColor Cyan
    $DOCKER_USERNAME = Read-Host
} else {
    $DOCKER_USERNAME = $args[0]
}

# Validate Docker username
if ([string]::IsNullOrEmpty($DOCKER_USERNAME)) {
    Write-Host "Error: Docker username cannot be empty" -ForegroundColor Red
    exit 1
}

Write-Host "Replacing `${DOCKER_USERNAME} with $DOCKER_USERNAME in deployment files..." -ForegroundColor Green

# Find all YAML files in the k8s directory and replace the placeholder
Get-ChildItem -Path . -Filter *.yaml -Recurse | ForEach-Object {
    (Get-Content $_.FullName) -replace '\$\{DOCKER_USERNAME\}', $DOCKER_USERNAME | Set-Content $_.FullName
}

Write-Host "Image names updated successfully!" -ForegroundColor Green
Write-Host "You can now build and push your Docker images with:" -ForegroundColor Yellow
Write-Host ".\build-push.ps1" -ForegroundColor Yellow 
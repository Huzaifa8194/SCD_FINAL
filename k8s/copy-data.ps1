# Get the backend pod name
$BACKEND_POD = kubectl get pods -l app=backend -o jsonpath="{.items[0].metadata.name}"

# Create data directory in the pod if it doesn't exist
Write-Host "Creating data directory in the pod..."
kubectl exec $BACKEND_POD -- mkdir -p /app/data

# Copy JSON files to the pod
Write-Host "Copying JSON files to the pod..."
kubectl cp ..\data\result.json ${BACKEND_POD}:/app/data/result.json
kubectl cp ..\data\ocrresult.json ${BACKEND_POD}:/app/data/ocrresult.json

# Create images directory if it doesn't exist
Write-Host "Creating images directory in the pod..."
kubectl exec $BACKEND_POD -- mkdir -p /app/data/downloaded_images

# Copy image files if they exist
if (Test-Path -Path "..\data\downloaded_images") {
    Write-Host "Copying image files to the pod..."
    $files = Get-ChildItem -Path "..\data\downloaded_images" -File
    foreach ($file in $files) {
        kubectl cp $file.FullName ${BACKEND_POD}:/app/data/downloaded_images/$($file.Name)
    }
} else {
    Write-Host "No images directory found at ..\data\downloaded_images"
}

Write-Host "Data copy complete!" 
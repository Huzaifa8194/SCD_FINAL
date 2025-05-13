# Kubernetes Deployment for Vehicle Data Management System

This directory contains Kubernetes manifests for deploying the Vehicle Data Management System on Kubernetes.

## Prerequisites

- Minikube installed and running
- kubectl configured to use Minikube
- Docker installed
- Docker Hub account (or another container registry)

## Directory Structure

```
k8s/
├── backend/
│   ├── backend-config.yaml
│   ├── backend-deployment.yaml
│   └── backend-service.yaml
├── frontend/
│   ├── frontend-deployment.yaml
│   └── frontend-service.yaml
├── mongodb/
│   ├── mongodb-deployment.yaml
│   ├── mongodb-pvc.yaml
│   └── mongodb-service.yaml
├── data-pvc.yaml
├── build-push.sh (or build-push.ps1 for Windows)
├── cleanup.sh (or cleanup.ps1 for Windows)
├── copy-data.sh (or copy-data.ps1 for Windows)
├── deploy.sh (or deploy.ps1 for Windows)
├── fix-images.sh (or fix-images.ps1 for Windows)
├── fix-storage.sh (or fix-storage.ps1 for Windows)
├── init-db.sh (or init-db.ps1 for Windows)
└── status.sh (or status.ps1 for Windows)
```

## Deployment Steps

### 1. Start Minikube

```bash
minikube start
```

### 2. Set Up Storage (Important)

Before deploying, make sure Minikube's storage provisioner is enabled:

```bash
# For Linux/Mac
chmod +x fix-storage.sh
./fix-storage.sh

# For Windows
.\fix-storage.ps1
```

This will:
- Enable the storage-provisioner and default-storageclass addons in Minikube
- Delete any existing PVCs that might be stuck in "Pending" state
- Create new PVCs with the correct storage class

### 3. Fix Image Names (Important)

The deployment files contain placeholder Docker image names that need to be replaced with your actual Docker username:

```bash
# For Linux/Mac
chmod +x fix-images.sh
./fix-images.sh

# For Windows
.\fix-images.ps1
```

This will replace `${DOCKER_USERNAME}` with your actual Docker username in the deployment files.

### 4. Build and Push Docker Images

Before deploying, you need to build and push the Docker images to a registry.

1. Edit the `build-push.sh` (or `build-push.ps1` for Windows) script and set your Docker Hub username.
2. Run the script:

```bash
# For Linux/Mac
chmod +x build-push.sh
./build-push.sh

# For Windows
.\build-push.ps1
```

### 5. Deploy the Application

```bash
# For Linux/Mac
chmod +x deploy.sh
./deploy.sh

# For Windows
.\deploy.ps1
```

### 6. Copy Data Files to the Pod

If you have existing data files (JSON files and images), you can copy them to the backend pod:

```bash
# For Linux/Mac
chmod +x copy-data.sh
./copy-data.sh

# For Windows
.\copy-data.ps1
```

### 7. Initialize the Database

After deployment is complete and data files are copied, initialize the database:

```bash
# For Linux/Mac
chmod +x init-db.sh
./init-db.sh

# For Windows
.\init-db.ps1
```

### 8. Check Deployment Status

To check the status of your deployment:

```bash
# For Linux/Mac
chmod +x status.sh
./status.sh

# For Windows
.\status.ps1
```

### 9. Access the Application

The frontend is exposed as a NodePort service on port 30080. To access it:

```bash
minikube ip
```

Then open your browser and navigate to `http://<minikube-ip>:30080`

## Cleaning Up

To delete all resources:

```bash
# For Linux/Mac
chmod +x cleanup.sh
./cleanup.sh

# For Windows
.\cleanup.ps1
```

This will remove all Kubernetes resources created for this application.

## Troubleshooting

### Image Name Issues

If you see `InvalidImageName` or `ImagePullBackOff` errors:

1. Make sure you've run the fix-images script:
   ```bash
   # For Linux/Mac
   ./fix-images.sh
   
   # For Windows
   .\fix-images.ps1
   ```

2. Check if your Docker images are properly built and pushed:
   ```bash
   docker images | grep vehicle
   ```

3. If you're using a private Docker registry, you may need to create a Kubernetes secret:
   ```bash
   kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-password>
   ```
   Then add it to your deployment files under `spec.template.spec.imagePullSecrets`.

### PersistentVolumeClaim Issues

If your PVCs are stuck in "Pending" state:

1. Make sure Minikube's storage provisioner is enabled:
   ```bash
   minikube addons enable storage-provisioner
   minikube addons enable default-storageclass
   ```

2. Check if a StorageClass exists:
   ```bash
   kubectl get storageclass
   ```

3. Run the fix-storage script:
   ```bash
   # For Linux/Mac
   ./fix-storage.sh
   
   # For Windows
   .\fix-storage.ps1
   ```

4. If issues persist, try recreating Minikube:
   ```bash
   minikube delete
   minikube start
   ```

### Pod Issues

To check pod status:

```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Service Issues

To check service status:

```bash
kubectl get svc
kubectl describe svc frontend
kubectl describe svc backend
kubectl describe svc mongodb
```

### Data Issues

If you're having issues with data access:

```bash
# Check if data files exist in the pod
kubectl exec <backend-pod-name> -- ls -la /app/data
kubectl exec <backend-pod-name> -- ls -la /app/data/downloaded_images

# Check MongoDB data
kubectl exec <mongodb-pod-name> -- mongo vehicle_db --eval "db.vehicles.find().count()"
kubectl exec <mongodb-pod-name> -- mongo vehicle_db --eval "db.ocrData.find().count()"
``` 
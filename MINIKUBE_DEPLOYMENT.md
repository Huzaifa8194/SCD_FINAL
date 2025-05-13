# Minikube Deployment with GitHub Actions

This guide explains how to set up a self-hosted GitHub Actions runner to deploy your application to a local Minikube cluster.

## Prerequisites

1. Docker installed on your local machine
2. Minikube installed and running
3. kubectl configured to use Minikube
4. GitHub repository with your code (https://github.com/Huzaifa8194/SCD_FINAL)

## Setup Instructions

### 1. Set Up Minikube

If you haven't already set up Minikube, follow these steps:

```bash
# Install Minikube (if not already installed)
# For Windows with Chocolatey:
choco install minikube

# For macOS with Homebrew:
brew install minikube

# Start Minikube
minikube start

# Verify Minikube is running
minikube status
```

### 2. Set Up GitHub Actions Self-Hosted Runner

#### Using the Setup Scripts (Recommended)

We've created scripts to automate the setup process:

**For Windows:**
```powershell
# Run the PowerShell script as administrator
.\scripts\setup-github-runner.ps1
```

**For Linux/macOS:**
```bash
# Make the script executable
chmod +x scripts/setup-github-runner.sh

# Run the script
./scripts/setup-github-runner.sh
```

The scripts will:
1. Create a directory for the runner
2. Download the appropriate runner package
3. Validate the package hash
4. Extract the package
5. Configure the runner with your repository
6. Provide instructions for starting the runner

#### Manual Setup

If you prefer to set up the runner manually:

1. Go to your GitHub repository
2. Navigate to Settings > Actions > Runners
3. Click "New self-hosted runner"
4. Select your operating system (Windows/Linux/macOS)
5. Follow the instructions provided by GitHub to download, configure, and run the self-hosted runner on your machine

Example for Windows:
```powershell
# Create a folder under the drive root
mkdir C:\actions-runner
cd C:\actions-runner

# Download the latest runner package
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-win-x64-2.323.0.zip -OutFile actions-runner-win-x64-2.323.0.zip

# Optional: Validate the hash
if((Get-FileHash -Path actions-runner-win-x64-2.323.0.zip -Algorithm SHA256).Hash.ToUpper() -ne 'e8ca92e3b1b907cdcc0c94640f4c5b23f377743993a4a5c859cb74f3e6eb33ef'.ToUpper()){ throw 'Computed checksum did not match' }

# Extract the installer
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.323.0.zip", "$PWD")

# Create the runner and start the configuration experience
./config.cmd --url https://github.com/Huzaifa8194/SCD_FINAL --token BC6JMJKA72CFO2LKKFTOZO3IEMR4C

# Run it!
./run.cmd
```

Example for Linux:
```bash
# Create a folder
mkdir -p ~/actions-runner && cd ~/actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.323.0.tar.gz

# Configure the runner
./config.sh --url https://github.com/Huzaifa8194/SCD_FINAL --token BC6JMJKA72CFO2LKKFTOZO3IEMR4C

# Run the runner
./run.sh
```

### 3. GitHub Secrets Setup

Add the following secrets to your GitHub repository:

1. Go to your GitHub repository > Settings > Secrets and variables > Actions
2. Add the following secrets:
   - `DOCKERHUB_TOKEN`: Your Docker Hub access token

### 4. Deployment Process

The GitHub Actions workflow is configured to:

1. Build the Docker image using Minikube's Docker daemon
2. Push the image to Docker Hub
3. Create a dedicated namespace (`vehicle-app`) in Kubernetes
4. Deploy the application to Minikube using Kubernetes manifests
5. Display information about the deployed resources

### 5. Accessing the Application

After successful deployment, the application will be accessible via:

```bash
minikube service frontend -n vehicle-app
```

This command will automatically open the application in your default web browser.

## Manual Deployment

If you want to deploy manually without waiting for GitHub Actions:

**For Windows:**
```powershell
.\scripts\minikube-deploy.ps1
```

**For Linux/macOS:**
```bash
./scripts/minikube-deploy.sh
```

## Troubleshooting

### Minikube Issues

- If Minikube is not starting properly, try:
  ```bash
  minikube delete
  minikube start
  ```

### Docker Connection Issues

- Ensure Docker is running
- Verify that you can connect to Minikube's Docker daemon:
  ```bash
  eval $(minikube docker-env)
  docker ps
  ```

### Kubernetes Deployment Issues

- Check pod status:
  ```bash
  kubectl get pods -n vehicle-app
  kubectl describe pod <pod-name> -n vehicle-app
  ```

- Check logs:
  ```bash
  kubectl logs <pod-name> -n vehicle-app
  ```

### GitHub Actions Runner Issues

- Verify the runner is online in your GitHub repository settings
- Check the runner logs for any errors
- Restart the runner if needed

## Cleaning Up

To delete all resources created by this deployment:

```bash
kubectl delete namespace vehicle-app
```

To stop Minikube:

```bash
minikube stop
``` 
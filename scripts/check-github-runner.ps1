# PowerShell script to check if the GitHub Actions runner is working properly
# This script will check if the runner is online and connected to GitHub

Write-Host "Checking GitHub Actions runner status..." -ForegroundColor Cyan

# Check if runner directory exists
$runnerDir = "C:\actions-runner"
if (-not (Test-Path $runnerDir)) {
    Write-Host "Runner directory not found at $runnerDir" -ForegroundColor Red
    Write-Host "Please make sure you've installed the GitHub Actions runner" -ForegroundColor Red
    exit 1
}

# Check if runner service is running
$runnerService = Get-Service -Name "actions.runner.*" -ErrorAction SilentlyContinue
if ($null -eq $runnerService) {
    Write-Host "GitHub Actions runner service not found" -ForegroundColor Red
    Write-Host "Please make sure the runner is installed as a service" -ForegroundColor Red
    
    # Check if runner is running as a process
    Write-Host "Checking if runner is running as a process..." -ForegroundColor Yellow
    $runnerProcess = Get-Process -Name "Runner.Listener" -ErrorAction SilentlyContinue
    if ($null -eq $runnerProcess) {
        Write-Host "Runner process not found" -ForegroundColor Red
        Write-Host "To start the runner manually, run:" -ForegroundColor Yellow
        Write-Host "cd $runnerDir" -ForegroundColor White
        Write-Host ".\run.cmd" -ForegroundColor White
    } else {
        Write-Host "Runner process is running" -ForegroundColor Green
    }
} else {
    Write-Host "GitHub Actions runner service is $($runnerService.Status)" -ForegroundColor Green
}

# Check if Docker is installed and running
$dockerService = Get-Service -Name "docker" -ErrorAction SilentlyContinue
if ($null -eq $dockerService) {
    Write-Host "Docker service not found" -ForegroundColor Red
    Write-Host "Please make sure Docker is installed" -ForegroundColor Red
} else {
    Write-Host "Docker service is $($dockerService.Status)" -ForegroundColor Green
    
    if ($dockerService.Status -ne "Running") {
        Write-Host "Docker service is not running. Starting Docker..." -ForegroundColor Yellow
        Start-Service -Name "docker"
    }
    
    # Test Docker
    try {
        $dockerVersion = docker version
        Write-Host "Docker is working properly" -ForegroundColor Green
    } catch {
        Write-Host "Error running Docker command: $_" -ForegroundColor Red
    }
}

# Check if minikube is installed and running
try {
    $minikubeStatus = minikube status
    if ($minikubeStatus -match "host: Running") {
        Write-Host "Minikube is running" -ForegroundColor Green
        
        # Test connection to minikube's Docker daemon
        Write-Host "Testing connection to minikube's Docker daemon..." -ForegroundColor Yellow
        try {
            minikube docker-env --shell powershell | Invoke-Expression
            $containers = docker ps
            Write-Host "Successfully connected to minikube's Docker daemon" -ForegroundColor Green
        } catch {
            Write-Host "Error connecting to minikube's Docker daemon: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Minikube is not running" -ForegroundColor Red
        Write-Host "To start minikube, run:" -ForegroundColor Yellow
        Write-Host "minikube start" -ForegroundColor White
    }
} catch {
    Write-Host "Error checking minikube status: $_" -ForegroundColor Red
    Write-Host "Please make sure minikube is installed" -ForegroundColor Red
}

Write-Host "`nTo trigger the GitHub Actions workflow manually:" -ForegroundColor Cyan
Write-Host "1. Go to your GitHub repository (https://github.com/Huzaifa8194/SCD_FINAL)" -ForegroundColor White
Write-Host "2. Navigate to Actions > Build and Deploy to Minikube" -ForegroundColor White
Write-Host "3. Click 'Run workflow' dropdown on the right side" -ForegroundColor White
Write-Host "4. Select the branch (main or master)" -ForegroundColor White
Write-Host "5. Click the green 'Run workflow' button" -ForegroundColor White 
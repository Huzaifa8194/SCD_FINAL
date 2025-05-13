# PowerShell script to set up GitHub Actions self-hosted runner
# This script will download and configure the GitHub Actions runner for your repository

# Set variables
$GITHUB_REPO_URL = "https://github.com/Huzaifa8194/SCD_FINAL"
$GITHUB_TOKEN = "BC6JMJKA72CFO2LKKFTOZO3IEMR4C"
$RUNNER_VERSION = "2.323.0"
$RUNNER_PACKAGE = "actions-runner-win-x64-$RUNNER_VERSION.zip"
$RUNNER_SHA256 = "e8ca92e3b1b907cdcc0c94640f4c5b23f377743993a4a5c859cb74f3e6eb33ef"

# Create runner directory at the drive root
Write-Host "Creating GitHub Actions runner directory..." -ForegroundColor Cyan
$runnerDir = "C:\actions-runner"

# Check if directory already exists
if (Test-Path $runnerDir) {
    Write-Host "Directory already exists. Do you want to remove it and start fresh? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -eq "Y" -or $response -eq "y") {
        Remove-Item -Path $runnerDir -Recurse -Force
    } else {
        Write-Host "Exiting setup. Please remove the directory manually or choose a different location." -ForegroundColor Red
        exit 1
    }
}

# Create directory and navigate to it
New-Item -ItemType Directory -Path $runnerDir -Force | Out-Null
Set-Location -Path $runnerDir
Write-Host "Working directory: $runnerDir" -ForegroundColor Green

# Download the runner package
Write-Host "Downloading GitHub Actions runner package..." -ForegroundColor Cyan
$downloadUrl = "https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/$RUNNER_PACKAGE"
Invoke-WebRequest -Uri $downloadUrl -OutFile $RUNNER_PACKAGE

# Validate the hash
Write-Host "Validating package hash..." -ForegroundColor Cyan
$fileHash = (Get-FileHash -Path $RUNNER_PACKAGE -Algorithm SHA256).Hash.ToUpper()
if ($fileHash -ne $RUNNER_SHA256.ToUpper()) {
    Write-Host "ERROR: Computed checksum did not match expected value!" -ForegroundColor Red
    Write-Host "Expected: $($RUNNER_SHA256.ToUpper())" -ForegroundColor Red
    Write-Host "Actual: $fileHash" -ForegroundColor Red
    exit 1
}
Write-Host "Hash validation successful!" -ForegroundColor Green

# Extract the installer
Write-Host "Extracting runner package..." -ForegroundColor Cyan
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$runnerDir\$RUNNER_PACKAGE", $runnerDir)

# Configure the runner
Write-Host "Configuring GitHub Actions runner..." -ForegroundColor Cyan
$configCmd = Join-Path -Path $runnerDir -ChildPath "config.cmd"
$configArgs = "--url $GITHUB_REPO_URL --token $GITHUB_TOKEN --unattended"
Start-Process -FilePath $configCmd -ArgumentList $configArgs -NoNewWindow -Wait

# Instructions to run the runner
Write-Host "`nSetup completed successfully!" -ForegroundColor Green
Write-Host "`nTo start the runner, run:" -ForegroundColor Yellow
Write-Host "cd $runnerDir" -ForegroundColor White
Write-Host ".\run.cmd" -ForegroundColor White

Write-Host "`nTo install as a service, run:" -ForegroundColor Yellow
Write-Host "cd $runnerDir" -ForegroundColor White
Write-Host ".\config.cmd --url $GITHUB_REPO_URL --token $GITHUB_TOKEN --runasservice" -ForegroundColor White

Write-Host "`nYour GitHub Actions workflow should use:" -ForegroundColor Yellow
Write-Host "runs-on: self-hosted" -ForegroundColor White

# Offer to run the runner now
Write-Host "`nDo you want to start the runner now? (Y/N)" -ForegroundColor Cyan
$runNow = Read-Host
if ($runNow -eq "Y" -or $runNow -eq "y") {
    Write-Host "Starting GitHub Actions runner..." -ForegroundColor Green
    $runCmd = Join-Path -Path $runnerDir -ChildPath "run.cmd"
    Start-Process -FilePath $runCmd -NoNewWindow
} 
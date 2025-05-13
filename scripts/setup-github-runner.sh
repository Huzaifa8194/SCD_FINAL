#!/bin/bash

# Bash script to set up GitHub Actions self-hosted runner
# This script will download and configure the GitHub Actions runner for your repository

# Set variables
GITHUB_REPO_URL="https://github.com/Huzaifa8194/SCD_FINAL"
GITHUB_TOKEN="BC6JMJKA72CFO2LKKFTOZO3IEMR4C"
RUNNER_VERSION="2.323.0"
RUNNER_PACKAGE="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUNNER_SHA256="5334b5a6ac60d9f0d9c3f951c5c4645ae5a3f4b8ea2bf72f5e0c0e7c1d5530c3"  # This is for Linux x64

# Create runner directory at the drive root
echo -e "\033[36mCreating GitHub Actions runner directory...\033[0m"
RUNNER_DIR="/actions-runner"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[33mNote: Not running as root. Using home directory instead of drive root.\033[0m"
  RUNNER_DIR="$HOME/actions-runner"
fi

# Check if directory already exists
if [ -d "$RUNNER_DIR" ]; then
  echo -e "\033[33mDirectory already exists. Do you want to remove it and start fresh? (Y/N)\033[0m"
  read -r response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    rm -rf "$RUNNER_DIR"
  else
    echo -e "\033[31mExiting setup. Please remove the directory manually or choose a different location.\033[0m"
    exit 1
  fi
fi

# Create directory and navigate to it
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR" || exit
echo -e "\033[32mWorking directory: $RUNNER_DIR\033[0m"

# Download the runner package
echo -e "\033[36mDownloading GitHub Actions runner package...\033[0m"
DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_PACKAGE}"
curl -o "$RUNNER_PACKAGE" -L "$DOWNLOAD_URL"

# Validate the hash
echo -e "\033[36mValidating package hash...\033[0m"
FILE_HASH=$(sha256sum "$RUNNER_PACKAGE" | cut -d' ' -f1)
if [ "${FILE_HASH^^}" != "${RUNNER_SHA256^^}" ]; then
  echo -e "\033[31mERROR: Computed checksum did not match expected value!\033[0m"
  echo -e "\033[31mExpected: ${RUNNER_SHA256^^}\033[0m"
  echo -e "\033[31mActual: ${FILE_HASH^^}\033[0m"
  exit 1
fi
echo -e "\033[32mHash validation successful!\033[0m"

# Extract the installer
echo -e "\033[36mExtracting runner package...\033[0m"
tar xzf "$RUNNER_PACKAGE"

# Set execute permissions
chmod +x ./config.sh
chmod +x ./run.sh

# Configure the runner
echo -e "\033[36mConfiguring GitHub Actions runner...\033[0m"
./config.sh --url "$GITHUB_REPO_URL" --token "$GITHUB_TOKEN" --unattended

# Instructions to run the runner
echo -e "\n\033[32mSetup completed successfully!\033[0m"
echo -e "\n\033[33mTo start the runner, run:\033[0m"
echo -e "cd $RUNNER_DIR"
echo -e "./run.sh"

echo -e "\n\033[33mTo install as a service, run:\033[0m"
echo -e "cd $RUNNER_DIR"
echo -e "./svc.sh install"
echo -e "./svc.sh start"

echo -e "\n\033[33mYour GitHub Actions workflow should use:\033[0m"
echo -e "runs-on: self-hosted"

# Offer to run the runner now
echo -e "\n\033[36mDo you want to start the runner now? (Y/N)\033[0m"
read -r run_now
if [[ "$run_now" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo -e "\033[32mStarting GitHub Actions runner...\033[0m"
  ./run.sh
fi 
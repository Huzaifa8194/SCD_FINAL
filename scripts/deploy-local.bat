@echo off
REM Script to pull the latest Docker image and deploy locally
REM This script should be executed after a new image is pushed to Docker Hub

REM Set variables
set DOCKER_USERNAME=huzaifa8195
set IMAGE_NAME=vehicle-frontend
set TAG=latest

echo Starting local deployment process...

REM Pull the latest image
echo Pulling the latest image from Docker Hub...
docker pull %DOCKER_USERNAME%/%IMAGE_NAME%:%TAG%

REM Stop and remove the existing container if it exists
echo Stopping existing container if running...
docker stop %IMAGE_NAME% 2>nul || echo Container not running
docker rm %IMAGE_NAME% 2>nul || echo Container not found

REM Run the new container
echo Starting new container...
docker run -d --name %IMAGE_NAME% -p 80:80 %DOCKER_USERNAME%/%IMAGE_NAME%:%TAG%

echo Deployment completed successfully!
echo Application is now running at http://localhost 
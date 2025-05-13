# Docker Hub and Automated Deployment Setup

This guide explains how to set up Docker Hub integration with GitHub Actions for automatic image building and pushing, followed by local deployment.

## Prerequisites

1. Docker installed on your local machine
2. Docker Hub account
3. GitHub repository with your code
4. Node.js installed (for running the webhook server)

## Setup Instructions

### 1. Docker Hub Setup

1. Create a Docker Hub account if you don't have one: [Docker Hub](https://hub.docker.com/)
2. Ensure you have access to the Docker Hub repositories:
   - `huzaifa8195/vehicle-frontend`
   - `huzaifa8195/vehicle-backend`
3. Generate an access token in Docker Hub:
   - Go to Account Settings > Security > New Access Token
   - Give it a name like "GitHub Actions"
   - Copy the token (you won't be able to see it again)

### 2. GitHub Secrets Setup

Add the following secrets to your GitHub repository:

1. Go to your GitHub repository > Settings > Secrets and variables > Actions
2. Add the following secrets:
   - `DOCKERHUB_USERNAME`: `huzaifa8195`
   - `DOCKERHUB_TOKEN`: The access token you generated in Docker Hub

### 3. GitHub Actions Workflow

The GitHub Actions workflow files are already set up in your repository:

- `.github/workflows/docker-build-push.yml`: Builds and pushes Docker images to Docker Hub
- `.github/workflows/trigger-local-deploy.yml`: Triggers local deployment after successful build

### 4. Local Deployment Setup

#### Option 1: Manual Deployment

After a successful build and push to Docker Hub, you can manually deploy the latest image:

**For Windows:**
```
scripts\deploy-local.bat
```

**For Linux/Mac:**
```
bash scripts/deploy-local.sh
```

The scripts are already configured with your Docker Hub username (`huzaifa8195`) and repository name (`vehicle-frontend`).

#### Option 2: Automated Deployment via Webhook

1. Start the webhook server on your local machine:

   **For Windows:**
   ```
   node scripts\webhook-server-windows.js
   ```

   **For Linux/Mac:**
   ```
   node scripts/webhook-server.js
   ```

2. Make your local webhook server accessible from the internet using a service like [ngrok](https://ngrok.com/):
   ```
   ngrok http 9000
   ```

3. Update the webhook URL in `.github/workflows/trigger-local-deploy.yml` with your ngrok URL:
   ```yaml
   curl -X POST -H "Content-Type: application/json" -d @payload.json https://your-ngrok-url/deploy
   ```

## Customization

### Modifying the Docker Image Name

The configuration is already set up for `huzaifa8195/vehicle-frontend`. If you need to use the backend image instead, edit the following files:

1. `.github/workflows/docker-build-push.yml`: Change all instances of `vehicle-frontend` to `vehicle-backend`
2. `scripts/deploy-local.sh`: Change `IMAGE_NAME="vehicle-frontend"` to `IMAGE_NAME="vehicle-backend"`
3. `scripts/deploy-local.bat`: Change `set IMAGE_NAME=vehicle-frontend` to `set IMAGE_NAME=vehicle-backend`

### Changing the Webhook Port

If you need to use a different port for the webhook server:

1. Edit the `PORT` variable in `scripts/webhook-server.js` or `scripts/webhook-server-windows.js`
2. Update your ngrok command to use the new port

## Troubleshooting

### Docker Build Fails

- Check your Dockerfile for errors
- Ensure all required files are included in your repository
- Verify GitHub Actions logs for specific error messages

### Local Deployment Issues

- Ensure Docker is running on your machine
- Check that your Docker Hub credentials are correct
- Verify network connectivity to Docker Hub
- Check webhook server logs for errors 
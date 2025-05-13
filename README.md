# Vehicle Data Management System

This project consists of a React frontend and a Node.js/Express/MongoDB backend for managing vehicle data.

## Project Structure

- `frontend/`: React frontend application
- `backend/`: Node.js/Express backend API
- `data/`: Shared data directory containing JSON files and images
- `k8s/`: Kubernetes manifests for deploying the application

## Prerequisites

- Docker and Docker Compose (for Docker deployment)
- Minikube, kubectl (for Kubernetes deployment)
- Node.js and npm (for local development)

## Getting Started

### Running with Docker Compose

The easiest way to run the entire application is using Docker Compose:

```bash
# Start all services
docker-compose up -d

# Initialize the database with data from JSON files
docker-compose exec backend npm run init-db
```

This will start:
- Frontend on http://localhost:8080
- Backend API on http://localhost:5000
- MongoDB on port 27017

### Running on Kubernetes with Minikube

For deploying on Kubernetes with Minikube, follow these steps:

1. Start Minikube:
   ```bash
   minikube start
   ```

2. Set up storage (important):
   ```bash
   cd k8s
   ./fix-storage.sh  # or .\fix-storage.ps1 on Windows
   ```

3. Fix image names (important):
   ```bash
   ./fix-images.sh  # or .\fix-images.ps1 on Windows
   ```

4. Build and push Docker images:
   ```bash
   # Update the Docker username in the build-push script first
   ./build-push.sh  # or .\build-push.ps1 on Windows
   ```

5. Deploy the application:
   ```bash
   ./deploy.sh  # or .\deploy.ps1 on Windows
   ```

6. Copy data files to the pod (if you have existing data):
   ```bash
   ./copy-data.sh  # or .\copy-data.ps1 on Windows
   ```

7. Initialize the database:
   ```bash
   ./init-db.sh  # or .\init-db.ps1 on Windows
   ```

8. Check deployment status:
   ```bash
   ./status.sh  # or .\status.ps1 on Windows
   ```

9. Access the application:
   ```bash
   minikube ip
   ```
   Then open your browser and navigate to `http://<minikube-ip>:30080`

10. To clean up when you're done:
    ```bash
    ./cleanup.sh  # or .\cleanup.ps1 on Windows
    ```

For more details, see the [Kubernetes deployment README](k8s/README.md).

### Running Locally (Development)

#### Backend

```bash
cd backend
npm install
npm run dev
```

The backend will be available at http://localhost:5000.

#### Frontend

```bash
npm install
npm start
```

The frontend will be available at http://localhost:3000.

## API Endpoints

### Vehicle Endpoints

- `GET /api/vehicles` - Get all vehicles
- `GET /api/vehicles/:stockNumber` - Get a specific vehicle by stock number
- `POST /api/vehicles` - Create a new vehicle
- `PUT /api/vehicles/:stockNumber` - Update a vehicle
- `DELETE /api/vehicles/:stockNumber` - Delete a vehicle
- `POST /api/vehicles/import` - Import vehicles from JSON file

### OCR Data Endpoints

- `GET /api/ocr` - Get all OCR data
- `GET /api/ocr/:stockNumber` - Get OCR data for a specific stock number
- `POST /api/ocr` - Create new OCR data
- `PUT /api/ocr/:stockNumber` - Update OCR data
- `DELETE /api/ocr/:stockNumber` - Delete OCR data
- `POST /api/ocr/import` - Import OCR data from JSON file

## Data Import

The backend provides endpoints to import data from JSON files located in the `data` directory:

- Vehicle data: `/data/result.json`
- OCR data: `/data/ocrresult.json`

## Development

For development, you can run the frontend and backend separately. The frontend is configured to proxy API requests to the backend during development.

## Troubleshooting

- If you encounter CORS issues, make sure the backend CORS settings are properly configured.
- If the database connection fails, check that MongoDB is running and accessible.
- For image loading issues, verify that the data directory is properly mounted in Docker or Kubernetes.
- For Kubernetes PVC issues, run the `fix-storage.sh/ps1` script to enable the storage provisioner in Minikube.
- For Kubernetes image issues, run the `fix-images.sh/ps1` script to replace placeholder image names with your Docker username.

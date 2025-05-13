# Vehicle Data Backend API

This is a RESTful API backend for the Vehicle Data application. It provides CRUD operations for vehicle and OCR data.

## Technologies Used

- Node.js
- Express.js
- MongoDB
- Docker

## Setup and Installation

### Prerequisites

- Docker and Docker Compose installed on your machine

### Installation

1. Clone the repository
2. Navigate to the backend directory
3. Run the following command to start the backend services:

```bash
docker-compose up -d
```

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

To run the backend in development mode:

```bash
npm run dev
```

This will start the server with nodemon, which will automatically restart the server when changes are detected.

## Production

For production deployment, make sure to set the `NODE_ENV` environment variable to `production` in the `.env` file or in the Docker Compose file. 
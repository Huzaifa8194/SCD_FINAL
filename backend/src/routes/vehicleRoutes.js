const express = require('express');
const router = express.Router();
const vehicleController = require('../controllers/vehicleController');

// Route to get all vehicles
router.get('/', vehicleController.getAllVehicles);

// Route to get a single vehicle by stock number
router.get('/:stockNumber', vehicleController.getVehicleByStockNumber);

// Route to create a new vehicle
router.post('/', vehicleController.createVehicle);

// Route to update a vehicle
router.put('/:stockNumber', vehicleController.updateVehicle);

// Route to delete a vehicle
router.delete('/:stockNumber', vehicleController.deleteVehicle);

// Route to import vehicles from JSON file
router.post('/import', vehicleController.importFromJson);

module.exports = router; 
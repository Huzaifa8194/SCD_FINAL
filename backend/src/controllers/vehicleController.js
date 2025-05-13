const Vehicle = require('../models/Vehicle');
const fs = require('fs');
const path = require('path');

// Get all vehicles
exports.getAllVehicles = async (req, res) => {
  try {
    const vehicles = await Vehicle.find();
    res.status(200).json(vehicles);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get a single vehicle by stock number
exports.getVehicleByStockNumber = async (req, res) => {
  try {
    const vehicle = await Vehicle.findOne({ stock_number: req.params.stockNumber });
    
    if (!vehicle) {
      return res.status(404).json({ message: 'Vehicle not found' });
    }
    
    res.status(200).json(vehicle);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create a new vehicle
exports.createVehicle = async (req, res) => {
  try {
    // Check if vehicle already exists
    const existingVehicle = await Vehicle.findOne({ stock_number: req.body.stock_number });
    
    if (existingVehicle) {
      return res.status(400).json({ message: 'Vehicle with this stock number already exists' });
    }
    
    const vehicle = new Vehicle(req.body);
    const savedVehicle = await vehicle.save();
    
    res.status(201).json(savedVehicle);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update a vehicle
exports.updateVehicle = async (req, res) => {
  try {
    const vehicle = await Vehicle.findOneAndUpdate(
      { stock_number: req.params.stockNumber },
      req.body,
      { new: true, runValidators: true }
    );
    
    if (!vehicle) {
      return res.status(404).json({ message: 'Vehicle not found' });
    }
    
    res.status(200).json(vehicle);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete a vehicle
exports.deleteVehicle = async (req, res) => {
  try {
    const vehicle = await Vehicle.findOneAndDelete({ stock_number: req.params.stockNumber });
    
    if (!vehicle) {
      return res.status(404).json({ message: 'Vehicle not found' });
    }
    
    res.status(200).json({ message: 'Vehicle deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Import vehicles from JSON file
exports.importFromJson = async (req, res) => {
  try {
    const jsonFilePath = path.join(__dirname, '../../../data/result.json');
    
    // Check if file exists
    if (!fs.existsSync(jsonFilePath)) {
      return res.status(404).json({ message: 'JSON file not found' });
    }
    
    // Read and parse JSON file
    const jsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
    
    // Process each vehicle
    const results = {
      total: jsonData.length,
      imported: 0,
      skipped: 0,
      errors: []
    };
    
    for (const item of jsonData) {
      try {
        // Check if vehicle already exists
        const existingVehicle = await Vehicle.findOne({ stock_number: item.stock_number });
        
        if (existingVehicle) {
          results.skipped++;
          continue;
        }
        
        // Create new vehicle
        const vehicle = new Vehicle(item);
        await vehicle.save();
        results.imported++;
      } catch (error) {
        results.errors.push({
          stock_number: item.stock_number,
          error: error.message
        });
      }
    }
    
    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 
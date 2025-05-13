const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

// Import models
const Vehicle = require('../models/Vehicle');
const OcrData = require('../models/OcrData');

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => {
    console.error('Failed to connect to MongoDB', err);
    process.exit(1);
  });

// Function to import vehicle data
const importVehicles = async () => {
  try {
    const jsonFilePath = path.join(__dirname, '../../../data/result.json');
    
    // Check if file exists
    if (!fs.existsSync(jsonFilePath)) {
      console.error('Vehicle JSON file not found');
      return;
    }
    
    // Read and parse JSON file
    const jsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
    
    console.log(`Found ${jsonData.length} vehicles in JSON file`);
    
    // Process each vehicle
    let imported = 0;
    let skipped = 0;
    let errors = 0;
    
    for (const item of jsonData) {
      try {
        // Check if vehicle already exists
        const existingVehicle = await Vehicle.findOne({ stock_number: item.stock_number });
        
        if (existingVehicle) {
          skipped++;
          continue;
        }
        
        // Create new vehicle
        const vehicle = new Vehicle(item);
        await vehicle.save();
        imported++;
      } catch (error) {
        console.error(`Error importing vehicle ${item.stock_number}:`, error.message);
        errors++;
      }
    }
    
    console.log(`Vehicle import completed: ${imported} imported, ${skipped} skipped, ${errors} errors`);
  } catch (error) {
    console.error('Error importing vehicles:', error);
  }
};

// Function to import OCR data
const importOcrData = async () => {
  try {
    const jsonFilePath = path.join(__dirname, '../../../data/ocrresult.json');
    
    // Check if file exists
    if (!fs.existsSync(jsonFilePath)) {
      console.error('OCR JSON file not found');
      return;
    }
    
    // Read and parse JSON file
    const jsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
    
    console.log(`Found ${jsonData.length} OCR records in JSON file`);
    
    // Process each OCR record
    let imported = 0;
    let skipped = 0;
    let errors = 0;
    
    for (const item of jsonData) {
      try {
        // Check if OCR data already exists
        const existingOcrData = await OcrData.findOne({ stock_number: item.stock_number });
        
        if (existingOcrData) {
          skipped++;
          continue;
        }
        
        // Create new OCR data
        const ocrData = new OcrData(item);
        await ocrData.save();
        imported++;
      } catch (error) {
        console.error(`Error importing OCR data ${item.stock_number}:`, error.message);
        errors++;
      }
    }
    
    console.log(`OCR data import completed: ${imported} imported, ${skipped} skipped, ${errors} errors`);
  } catch (error) {
    console.error('Error importing OCR data:', error);
  }
};

// Run the import functions
const runImport = async () => {
  try {
    await importVehicles();
    await importOcrData();
    console.log('Database initialization completed');
    process.exit(0);
  } catch (error) {
    console.error('Error during database initialization:', error);
    process.exit(1);
  }
};

runImport(); 
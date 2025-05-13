const OcrData = require('../models/OcrData');
const fs = require('fs');
const path = require('path');

// Get all OCR data
exports.getAllOcrData = async (req, res) => {
  try {
    const ocrData = await OcrData.find();
    res.status(200).json(ocrData);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get OCR data by stock number
exports.getOcrDataByStockNumber = async (req, res) => {
  try {
    const ocrData = await OcrData.findOne({ stock_number: req.params.stockNumber });
    
    if (!ocrData) {
      return res.status(404).json({ message: 'OCR data not found' });
    }
    
    res.status(200).json(ocrData);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create new OCR data
exports.createOcrData = async (req, res) => {
  try {
    // Check if OCR data already exists
    const existingOcrData = await OcrData.findOne({ stock_number: req.body.stock_number });
    
    if (existingOcrData) {
      return res.status(400).json({ message: 'OCR data with this stock number already exists' });
    }
    
    const ocrData = new OcrData(req.body);
    const savedOcrData = await ocrData.save();
    
    res.status(201).json(savedOcrData);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update OCR data
exports.updateOcrData = async (req, res) => {
  try {
    const ocrData = await OcrData.findOneAndUpdate(
      { stock_number: req.params.stockNumber },
      req.body,
      { new: true, runValidators: true }
    );
    
    if (!ocrData) {
      return res.status(404).json({ message: 'OCR data not found' });
    }
    
    res.status(200).json(ocrData);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete OCR data
exports.deleteOcrData = async (req, res) => {
  try {
    const ocrData = await OcrData.findOneAndDelete({ stock_number: req.params.stockNumber });
    
    if (!ocrData) {
      return res.status(404).json({ message: 'OCR data not found' });
    }
    
    res.status(200).json({ message: 'OCR data deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Import OCR data from JSON file
exports.importFromJson = async (req, res) => {
  try {
    const jsonFilePath = path.join(__dirname, '../../../data/ocrresult.json');
    
    // Check if file exists
    if (!fs.existsSync(jsonFilePath)) {
      return res.status(404).json({ message: 'JSON file not found' });
    }
    
    // Read and parse JSON file
    const jsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
    
    // Process each OCR data entry
    const results = {
      total: jsonData.length,
      imported: 0,
      skipped: 0,
      errors: []
    };
    
    for (const item of jsonData) {
      try {
        // Check if OCR data already exists
        const existingOcrData = await OcrData.findOne({ stock_number: item.stock_number });
        
        if (existingOcrData) {
          results.skipped++;
          continue;
        }
        
        // Create new OCR data
        const ocrData = new OcrData(item);
        await ocrData.save();
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
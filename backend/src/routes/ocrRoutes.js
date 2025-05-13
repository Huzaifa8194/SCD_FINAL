const express = require('express');
const router = express.Router();
const ocrController = require('../controllers/ocrController');

// Route to get all OCR data
router.get('/', ocrController.getAllOcrData);

// Route to get OCR data by stock number
router.get('/:stockNumber', ocrController.getOcrDataByStockNumber);

// Route to create new OCR data
router.post('/', ocrController.createOcrData);

// Route to update OCR data
router.put('/:stockNumber', ocrController.updateOcrData);

// Route to delete OCR data
router.delete('/:stockNumber', ocrController.deleteOcrData);

// Route to import OCR data from JSON file
router.post('/import', ocrController.importFromJson);

module.exports = router; 
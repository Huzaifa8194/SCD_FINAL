const mongoose = require('mongoose');

const OcrDataSchema = new mongoose.Schema({
  stock_number: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  vinnumber: {
    type: String,
    required: false
  },
  additional_data: {
    type: Map,
    of: String,
    default: {}
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});

// Update the 'updated_at' field on save
OcrDataSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

module.exports = mongoose.model('OcrData', OcrDataSchema); 
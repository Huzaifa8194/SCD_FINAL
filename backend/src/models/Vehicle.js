const mongoose = require('mongoose');

const VehicleSchema = new mongoose.Schema({
  stock_number: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  timestamp: {
    type: String,
    required: false
  },
  Final_Bid: {
    type: String,
    required: false
  },
  Details: {
    type: Map,
    of: String,
    default: {}
  },
  VINDisplay: {
    type: String,
    required: false
  },
  stock_number_href: {
    type: String,
    required: false
  },
  images: [{
    type: String,
    required: false
  }],
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
VehicleSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

module.exports = mongoose.model('Vehicle', VehicleSchema); 
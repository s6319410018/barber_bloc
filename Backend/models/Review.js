const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  barberId: { type: mongoose.Schema.Types.ObjectId, ref: 'Barber', required: true },
  rating: { type: Number, required: true },
  comment: String,
  date: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Review', reviewSchema);

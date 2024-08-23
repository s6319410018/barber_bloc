const mongoose = require('mongoose');

const barberSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  specialization: String,
  experience: Number,
  availability: [
    {
      day: String,
      timeSlots: [
        {
          start: String,
          end: String,
        },
      ],
    },
  ],
  reviews: [
    {
      reviewId: mongoose.Schema.Types.ObjectId,
      customerId: mongoose.Schema.Types.ObjectId,
      rating: Number,
      comment: String,
      date: Date,
    },
  ],
});

module.exports = mongoose.model('Barber', barberSchema);

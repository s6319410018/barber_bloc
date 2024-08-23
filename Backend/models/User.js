const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: { type: String, unique: true },
  email: { type: String, required: true, unique: true },
  passwordHash: { type: String, required: true },
  role: { type: String, enum: ['customer', 'barber'] },
  profile: {
    firstName: String,
    lastName: String,
    phoneNumber: String,
    address: String,
    picture: String,
  },
  appointments: [
    {
      appointmentId: mongoose.Schema.Types.ObjectId,
      dateTime: Date,
      service: String,
      status: { type: String, enum: ['pending', 'confirmed', 'completed', 'canceled'] },
    },
  ],
  reviews: [
    {
      reviewId: mongoose.Schema.Types.ObjectId,
      barberId: mongoose.Schema.Types.ObjectId,
      rating: Number,
      comment: String,
      date: Date,
    },
  ],
});

module.exports = mongoose.model('User', userSchema);

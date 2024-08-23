const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  message: { 
    type: String, 
    required: true, 
    minlength: 1, 
    maxlength: 500  
  },
});


module.exports = mongoose.model('Feedback', userSchema);

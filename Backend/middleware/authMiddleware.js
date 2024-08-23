const jwt = require('jsonwebtoken');
const User = require('../models/User'); 


const authMiddleware = async (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');


  if (!token) {
    return res.status(401).json({ message: 'No token provided' });
  }

  try {
 
    const decoded = jwt.verify(token, process.env.JWT_SECRET);


    const currentTime = Math.floor(Date.now() / 1000); 
    if (decoded.exp < currentTime) {
      return res.status(401).json({ message: 'Token has expired' }); 
    }

    const user = await User.findById(decoded.userId);


    if (!user) {
      return res.status(401).json({ message: 'Invalid token' }); 
    }

    req.userId = user; 
    next(); 
  } catch (error) {
    res.status(401).json({ message: 'Invalid token' }); 
  }
};
const authValidatetoken = async (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');


  if (!token) {
    return res.status(401).json({ message: 'No token provided' });
  }

  try {
 
    const decoded = jwt.verify(token, process.env.JWT_SECRET);


    const currentTime = Math.floor(Date.now() / 1000); 
    if (decoded.exp < currentTime) {
      return res.status(401).json({ message: true }); 
    }else{
      return res.status(200).json({ message: false }); 
    }

  } catch (error) {
    res.status(200).json({ message: 'Invalid token' }); 
  }
};



module.exports = {authMiddleware,authValidatetoken};

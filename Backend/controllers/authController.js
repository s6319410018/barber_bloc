const User = require("../models/User");
const Feedback = require('../models/Feedback'); // Adjust the path as necessary

const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
require("dotenv").config(); // สำหรับการเข้าถึงตัวแปรสภาพแวดล้อม

const HttpStatusCodes = {
  created: 201,
  badRequest: 400,
  unauthorized: 401,
  forbidden: 403,
  notFound: 404,
  internalServerError: 500,
};

// ลงทะเบียนผู้ใช้ใหม่

const register = async (req, res) => {
  try {
    const { username, email, password, role } = req.body;

    // Check if any required field is missing or empty
    if (!username || !email || !password || !role) {
      return res
        .status(HttpStatusCodes.badRequest)
        .json({ message: "Some fields are missing or empty" });
    }

    // Validate email format using a regular expression
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res
        .status(HttpStatusCodes.badRequest)
        .json({ message: "Invalid email format" });
    }

    // Check if the user already exists
    const existingUsername = await User.findOne({ username });
    if (existingUsername) {
      console.log(existingUsername);
      return res
        .status(HttpStatusCodes.badRequest)
        .json({ message: "Username already exists" });
    }
    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      console.log(existingEmail);
      return res
        .status(HttpStatusCodes.badRequest)
        .json({ message: "Email already exists" });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log(hashedPassword); // Log the hashed password for debugging

    // Create a new user
    const newUser = new User({
      username,
      email,
      role, // Include role in user creation
      passwordHash: hashedPassword, // Use passwordHash instead of password
    });

    await newUser.save(); // Save the new user in the database
    res
      .status(HttpStatusCodes.created)
      .json({ message: "User registered successfully" }); // Respond with success message
  } catch (error) {
    // Handle specific errors
    if (error.name === "ValidationError") {
      return res
        .status(HttpStatusCodes.badRequest)
        .json({ message: "Validation error", error: error.message });
    }

    // Catch other errors
    res
      .status(HttpStatusCodes.internalServerError)
      .json({ message: "Internal server error", error: error.message }); // Respond with error message
  }
};

// เข้าสู่ระบบผู้ใช้
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Some fields are missing or empty" });
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ message: "Invalid email format" });
    }
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ message: "Invalid email" });
    }
    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid password" });
    }
    if (!process.env.JWT_SECRET) {
      throw new Error("JWT_SECRET is not defined");
    }
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    res.status(200).json({ token });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// รับข้อมูลผู้ใช้จาก token
const getUserInfo = async (req, res) => {
  try {
    const user = await User.findById(req.userId);

    // Check if the user exists
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Respond with user information
    res.status(200).json({
      username: user.username,
      email: user.email,
      role: user.role,
      appointments: user.appointments,
      reviews: user.reviews,
      profile: user.profile,
    });
  } catch (error) {
    // Respond with a 500 status code and the error message
    console.error("Error fetching user info:", error.message); // Log detailed error
    res
      .status(500)
      .json({ message: "An error occurred while fetching user info" });
  }
};

// อัปเดตข้อมูลผู้ใช้
const updateUser = async (req, res) => {
  try {
    const { email, username, profile } = req.body;
    console.log(profile);
    if (!email) {
      return res
        .status(400)
        .json({ message: "Email is required for updating user" });
    }

    const updates = {};

    if (username) {
      updates.username = username;
    }

    if (profile) {
      const { firstName, lastName, phoneNumber, address, picture } = profile;
      if (firstName) updates["profile.firstName"] = firstName;
      if (lastName) updates["profile.lastName"] = lastName;
      if (phoneNumber) updates["profile.phoneNumber"] = phoneNumber;
      if (address) updates["profile.address"] = address;
      if (picture) updates["profile.picture"] = picture;
    }

    const updatedUser = await User.findOneAndUpdate({ email }, updates, {
      new: true,
    });

    if (!updatedUser) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({
      message: "Update Successfully",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Error updating user:", error.message);
    res.status(500).json({ message: "Server error" });
  }
};

const deleteUser = async (req, res) => {
  try {
    // Log the entire request body for debugging
    console.log('Request body:', req.body);

    const { email, message } = req.body;

    // Check for missing email
    if (!email) {
      console.log('Error: Email is missing');
      return res.status(400).json({ message: "Email is required" });
    }
    
    // Check for missing or invalid message
    if (!message || typeof message !== "string") {
      console.log('Error: Message is missing or not a string');
      return res.status(400).json({ error: "Message is required and must be a string" });
    }

    // Sanitize message
    const sanitizedMessage = message.replace(/[^\w\s]/gi, "");
    console.log('Sanitized message:', sanitizedMessage);

    // Create a new Feedback document
    const newFeedback = new Feedback({ message: sanitizedMessage });
    await newFeedback.save();
    console.log('Feedback saved:', newFeedback);

    // Delete the user from the database
    const deletedUser = await User.findOneAndDelete({ email });
    console.log('Deleted user:', deletedUser);

    if (!deletedUser) {
      console.log('Error: User not found');
      return res.status(404).json({ message: "User not found" });
    }

    // Respond with success
    console.log('User deleted successfully');
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    // Log error and respond with server error
    console.log('Server error:', error);
    res.status(500).json({ error: error.message });
  }
};


module.exports = {
  register,
  login,
  getUserInfo,
  updateUser,
  deleteUser,
};

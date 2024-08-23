const express = require('express');
const { authMiddleware } = require('../middleware/authMiddleware'); // Ensure this path is correct
const Controller = require('../controllers/feedbackController'); // Ensure this path is correct
const router = express.Router();

router.post('/feedback', authMiddleware, Controller.FeedbackCtrl);

module.exports = router;

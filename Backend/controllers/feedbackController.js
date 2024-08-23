const Feedback = require("../models/Feedback");

const FeedbackCtrl = async (req, res) => {
  try {
    const { message } = req.body;

    if (!message || typeof message !== "string") {
      return res
        .status(400)
        .json({ error: "Message is required and must be a string" });
    }

    const sanitizedMessage = message.replace(/[^\w\s]/gi, "");

    const newFeedback = new Feedback({ message: sanitizedMessage });

    await newFeedback.save();

    // Respond with success
    res
      .status(201)
      .json({ success: true, message: "Feedback submitted successfully" });
  } catch (error) {
    console.error("Error in FeedbackCtrl:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = { FeedbackCtrl };

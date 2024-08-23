const Review = require('../models/Review'); // นำเข้ามอเดลรีวิว
const Barber = require('../models/Barber'); // นำเข้ามอเดลช่างตัดผม

// สร้างรีวิวใหม่
const createReview = async (req, res) => {
  try {
    const { barberId, rating, comment } = req.body;

    // ตรวจสอบว่าช่างตัดผมที่ถูกรีวิวมีอยู่หรือไม่
    const barber = await Barber.findById(barberId);
    if (!barber) {
      return res.status(404).json({ message: 'Barber not found' });
    }

    // สร้างรีวิวใหม่
    const newReview = new Review({
      barberId,
      rating,
      comment,
      userId: req.user.userId, // ใช้ userId จากข้อมูลใน token
    });

    await newReview.save(); // บันทึกรีวิวใหม่ในฐานข้อมูล

    // อัปเดตราคาคะแนนเฉลี่ยของช่างตัดผม
    barber.rating = (barber.rating * barber.reviewsCount + rating) / (barber.reviewsCount + 1);
    barber.reviewsCount += 1;
    await barber.save();

    res.status(201).json(newReview); // ตอบกลับด้วยสถานะ 201 และข้อมูลรีวิว
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับรีวิวทั้งหมดของช่างตัดผม
const getReviewsByBarber = async (req, res) => {
  try {
    const reviews = await Review.find({ barberId: req.params.barberId }); // ดึงข้อมูลรีวิวทั้งหมดของช่างตัดผมตาม ID
    res.status(200).json(reviews); // ตอบกลับด้วยสถานะ 200 และข้อมูลรีวิวทั้งหมด
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับรีวิวตาม ID
const getReviewById = async (req, res) => {
  try {
    const review = await Review.findById(req.params.id); // ดึงข้อมูลรีวิวตาม ID
    if (!review) {
      return res.status(404).json({ message: 'Review not found' }); // ข้อความเมื่อไม่พบรีวิว
    }
    res.status(200).json(review); // ตอบกลับด้วยสถานะ 200 และข้อมูลรีวิว
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// อัปเดตรีวิว
const updateReview = async (req, res) => {
  try {
    const { rating, comment } = req.body;

    // ตรวจสอบว่ารีวิวมีอยู่หรือไม่และเป็นของผู้ใช้หรือไม่
    const review = await Review.findById(req.params.id);
    if (!review) {
      return res.status(404).json({ message: 'Review not found' });
    }
    if (review.userId.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Unauthorized' }); // ข้อความเมื่อผู้ใช้ไม่ได้เป็นเจ้าของรีวิว
    }

    // อัปเดตรีวิว
    review.rating = rating || review.rating;
    review.comment = comment || review.comment;
    await review.save();

    res.status(200).json(review); // ตอบกลับด้วยสถานะ 200 และข้อมูลรีวิวที่อัปเดต
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// ลบรีวิว
const deleteReview = async (req, res) => {
  try {
    const review = await Review.findById(req.params.id); // ตรวจสอบว่ารีวิวมีอยู่หรือไม่
    if (!review) {
      return res.status(404).json({ message: 'Review not found' });
    }
    if (review.userId.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Unauthorized' }); // ข้อความเมื่อผู้ใช้ไม่ได้เป็นเจ้าของรีวิว
    }

    await review.remove(); // ลบรีวิว
    res.status(200).json({ message: 'Review deleted successfully' }); // ตอบกลับด้วยข้อความยืนยันการลบ
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

module.exports = {
  createReview,
  getReviewsByBarber,
  getReviewById,
  updateReview,
  deleteReview,
};

const Barber = require('../models/Barber'); // นำเข้ามอเดลช่างตัดผม

// สร้างช่างตัดผมใหม่
const createBarber = async (req, res) => {
  try {
    const { name, services, availability, rating } = req.body;

    // สร้างช่างตัดผมใหม่
    const newBarber = new Barber({
      name,
      services,
      availability,
      rating,
    });

    await newBarber.save(); // บันทึกข้อมูลช่างตัดผมใหม่ในฐานข้อมูล
    res.status(201).json(newBarber); // ตอบกลับด้วยสถานะ 201 และข้อมูลช่างตัดผม
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับข้อมูลช่างตัดผมทั้งหมด
const getAllBarbers = async (req, res) => {
  try {
    const barbers = await Barber.find(); // ดึงข้อมูลช่างตัดผมทั้งหมด
    res.status(200).json(barbers); // ตอบกลับด้วยสถานะ 200 และข้อมูลช่างตัดผมทั้งหมด
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับข้อมูลช่างตัดผมตาม ID
const getBarberById = async (req, res) => {
  try {
    const barber = await Barber.findById(req.params.id); // ดึงข้อมูลช่างตัดผมตาม ID
    if (!barber) {
      return res.status(404).json({ message: 'Barber not found' }); // ข้อความเมื่อไม่พบช่างตัดผม
    }
    res.status(200).json(barber); // ตอบกลับด้วยสถานะ 200 และข้อมูลช่างตัดผม
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// อัปเดตข้อมูลช่างตัดผม
const updateBarber = async (req, res) => {
  try {
    const updatedBarber = await Barber.findByIdAndUpdate(req.params.id, req.body, { new: true }); // อัปเดตข้อมูลช่างตัดผม
    if (!updatedBarber) {
      return res.status(404).json({ message: 'Barber not found' }); // ข้อความเมื่อไม่พบช่างตัดผม
    }
    res.status(200).json(updatedBarber); // ตอบกลับด้วยสถานะ 200 และข้อมูลช่างตัดผมที่อัปเดต
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// ลบข้อมูลช่างตัดผม
const deleteBarber = async (req, res) => {
  try {
    const deletedBarber = await Barber.findByIdAndDelete(req.params.id); // ลบช่างตัดผมตาม ID
    if (!deletedBarber) {
      return res.status(404).json({ message: 'Barber not found' }); // ข้อความเมื่อไม่พบช่างตัดผม
    }
    res.status(200).json({ message: 'Barber deleted successfully' }); // ตอบกลับด้วยข้อความยืนยันการลบ
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

module.exports = {
  createBarber,
  getAllBarbers,
  getBarberById,
  updateBarber,
  deleteBarber,
};

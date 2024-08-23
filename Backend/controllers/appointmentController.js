const Appointment = require('../models/Appointment'); // นำเข้ามอเดลการจอง

// สร้างการจองใหม่
const createAppointment = async (req, res) => {
  try {
    const newAppointment = new Appointment(req.body);
    await newAppointment.save(); // บันทึกการจองใหม่ลงในฐานข้อมูล
    res.status(201).json(newAppointment); // ตอบกลับด้วยสถานะ 201 และข้อมูลการจอง
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับการจองทั้งหมด
const getAllAppointments = async (req, res) => {
  try {
    const appointments = await Appointment.find(); // ดึงข้อมูลการจองทั้งหมด
    res.status(200).json(appointments); // ตอบกลับด้วยสถานะ 200 และข้อมูลการจอง
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับการจองโดย ID
const getAppointmentById = async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.id); // ดึงข้อมูลการจองตาม ID
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' }); // ข้อความเมื่อไม่พบการจอง
    }
    res.status(200).json(appointment); // ตอบกลับด้วยสถานะ 200 และข้อมูลการจอง
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// อัปเดตการจอง
const updateAppointment = async (req, res) => {
  try {
    const updatedAppointment = await Appointment.findByIdAndUpdate(req.params.id, req.body, { new: true }); // อัปเดตการจอง
    if (!updatedAppointment) {
      return res.status(404).json({ message: 'Appointment not found' }); // ข้อความเมื่อไม่พบการจอง
    }
    res.status(200).json(updatedAppointment); // ตอบกลับด้วยสถานะ 200 และข้อมูลการจองที่อัปเดต
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// ลบการจอง
const deleteAppointment = async (req, res) => {
  try {
    const deletedAppointment = await Appointment.findByIdAndDelete(req.params.id); // ลบการจองตาม ID
    if (!deletedAppointment) {
      return res.status(404).json({ message: 'Appointment not found' }); // ข้อความเมื่อไม่พบการจอง
    }
    res.status(200).json({ message: 'Appointment deleted successfully' }); // ตอบกลับด้วยข้อความยืนยันการลบ
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

module.exports = {
  createAppointment,
  getAllAppointments,
  getAppointmentById,
  updateAppointment,
  deleteAppointment,
};

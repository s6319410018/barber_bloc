const Service = require('../models/Service'); // นำเข้ามอเดลบริการ

// สร้างบริการใหม่
const createService = async (req, res) => {
  try {
    const { name, description, price } = req.body;

    // สร้างบริการใหม่
    const newService = new Service({
      name,
      description,
      price,
    });

    await newService.save(); // บันทึกข้อมูลบริการใหม่ในฐานข้อมูล
    res.status(201).json(newService); // ตอบกลับด้วยสถานะ 201 และข้อมูลบริการ
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับบริการทั้งหมด
const getAllServices = async (req, res) => {
  try {
    const services = await Service.find(); // ดึงข้อมูลบริการทั้งหมด
    res.status(200).json(services); // ตอบกลับด้วยสถานะ 200 และข้อมูลบริการทั้งหมด
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// รับบริการตาม ID
const getServiceById = async (req, res) => {
  try {
    const service = await Service.findById(req.params.id); // ดึงข้อมูลบริการตาม ID
    if (!service) {
      return res.status(404).json({ message: 'Service not found' }); // ข้อความเมื่อไม่พบบริการ
    }
    res.status(200).json(service); // ตอบกลับด้วยสถานะ 200 และข้อมูลบริการ
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// อัปเดตบริการ
const updateService = async (req, res) => {
  try {
    const { name, description, price } = req.body;

    // อัปเดตข้อมูลบริการ
    const updatedService = await Service.findByIdAndUpdate(
      req.params.id,
      { name, description, price },
      { new: true }
    );

    if (!updatedService) {
      return res.status(404).json({ message: 'Service not found' }); // ข้อความเมื่อไม่พบบริการ
    }
    res.status(200).json(updatedService); // ตอบกลับด้วยสถานะ 200 และข้อมูลบริการที่อัปเดต
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

// ลบบริการ
const deleteService = async (req, res) => {
  try {
    const deletedService = await Service.findByIdAndDelete(req.params.id); // ลบบริการตาม ID
    if (!deletedService) {
      return res.status(404).json({ message: 'Service not found' }); // ข้อความเมื่อไม่พบบริการ
    }
    res.status(200).json({ message: 'Service deleted successfully' }); // ตอบกลับด้วยข้อความยืนยันการลบ
  } catch (error) {
    res.status(500).json({ error: error.message }); // ตอบกลับข้อผิดพลาด
  }
};

module.exports = {
  createService,
  getAllServices,
  getServiceById,
  updateService,
  deleteService,
};

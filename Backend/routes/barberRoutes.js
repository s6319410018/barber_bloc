const express = require('express');
const router = express.Router();
const barberController = require('../controllers/barberController');
const {authMiddleware,authValidatetoken} = require('../middleware/authMiddleware'); // ใช้ middleware สำหรับการพิสูจน์ตัวตน

// สร้างข้อมูลช่างตัดผมใหม่
router.post('/', authMiddleware, barberController.createBarber);

// รับข้อมูลช่างตัดผมทั้งหมด
router.get('/', barberController.getAllBarbers);

// รับข้อมูลช่างตัดผมตาม ID
router.get('/:id', barberController.getBarberById);

// อัปเดตข้อมูลช่างตัดผม
router.patch('/:id', authMiddleware, barberController.updateBarber);

// ลบข้อมูลช่างตัดผม
router.delete('/:id', authMiddleware, barberController.deleteBarber);

module.exports = router;

const express = require('express');
const router = express.Router();
const appointmentController = require('../controllers/appointmentController');
const {authMiddleware,authValidatetoken} = require('../middleware/authMiddleware'); // ใช้ middleware สำหรับการพิสูจน์ตัวตน

// สร้างการนัดหมายใหม่
router.post('/', authMiddleware, appointmentController.createAppointment);

// รับการนัดหมายทั้งหมด
router.get('/', authMiddleware, appointmentController.getAllAppointments);

// รับการนัดหมายตาม ID
router.get('/:id', authMiddleware, appointmentController.getAppointmentById);

// อัปเดตการนัดหมาย
router.patch('/:id', authMiddleware, appointmentController.updateAppointment);

// ลบการนัดหมาย
router.delete('/:id', authMiddleware, appointmentController.deleteAppointment);

module.exports = router;

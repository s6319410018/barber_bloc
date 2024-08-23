const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');
const {authMiddleware,authValidatetoken} = require('../middleware/authMiddleware'); // ใช้ middleware สำหรับการพิสูจน์ตัวตน

// สร้างบริการใหม่
router.post('/', authMiddleware, serviceController.createService);

// รับบริการทั้งหมด
router.get('/', serviceController.getAllServices);

// รับบริการตาม ID
router.get('/:id', serviceController.getServiceById);

// อัปเดตบริการตาม ID
router.patch('/:id', authMiddleware, serviceController.updateService);

// ลบบริการตาม ID
router.delete('/:id', authMiddleware, serviceController.deleteService);

module.exports = router;

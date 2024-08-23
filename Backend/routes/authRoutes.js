const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const {
  authMiddleware,
  authValidatetoken,
} = require("../middleware/authMiddleware"); // ใช้ middleware สำหรับการพิสูจน์ตัวตน

// ลงทะเบียนผู้ใช้ใหม่
router.post("/register", authController.register);

// เข้าสู่ระบบผู้ใช้
router.post("/login", authController.login);

// รับข้อมูลผู้ใช้
router.get("/me", authMiddleware, authController.getUserInfo);

// อัปเดตข้อมูลผู้ใช้
router.patch("/me", authMiddleware, authController.updateUser);

// ลบผู้ใช้
router.delete("/me", authMiddleware, authController.deleteUser);

router.get("/expire_token", authValidatetoken);

module.exports = router;

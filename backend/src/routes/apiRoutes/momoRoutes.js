const express=require("express");
const router= express.Router();
const momoController = require("../../controllers/api/momoAPI/momoController");
const { verifyToken } = require("../../middlewares/auth/firebase");
router.post("/createPayment",verifyToken,momoController.createPayment)
router.post("/callback",momoController.ipnCallback)



module.exports=router
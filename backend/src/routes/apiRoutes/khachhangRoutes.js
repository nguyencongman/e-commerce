const express=require("express");
const router=express.Router();
const khachhangAPI=require("../../controllers/api/khachhangAPI");
const limiter = require("../../middlewares/redis/limiter/limiter")
const firebase= require("../../middlewares/auth/firebase")

router.post("/",limiter.createLimit(3,60),firebase.verifyToken,khachhangAPI.signup)
router.post("/signin",firebase.verifyToken, khachhangAPI.signin)
router.post("/signin2", khachhangAPI.signin)

router.get("/makh",firebase.verifyToken,khachhangAPI.getCustomerById)
router.put("/",firebase.verifyToken,khachhangAPI.updateCustomer);

module.exports=router
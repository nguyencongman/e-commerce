const CartItemAPI = require("../../controllers/api/CartItemAPI");
const express = require("express");
const router = express.Router();
const limiter=require("../../middlewares/redis/limiter/limiter");
const { verifyToken } = require("../../middlewares/auth/firebase");

//,verifyToken
router.get("/",CartItemAPI.getCartItem);
router.post("/",verifyToken,CartItemAPI.addOrUpdateItem);
router.post("/increaseQuantityItem",limiter.createLimit(20,15),verifyToken,CartItemAPI.increaseQuantityItem)
router.post("/decreaseQuantityItem",limiter.createLimit(20,15),verifyToken,CartItemAPI.decreaseQuantityItem)
router.delete("/",verifyToken,CartItemAPI.deleteItem);

module.exports=router;
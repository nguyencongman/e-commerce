const favoriteApi= require("../../controllers/api/favoriteAPI");
const express = require("express");
const router = express.Router();
const firebase = require("../../middlewares/auth/firebase");
const { createLimit } = require("../../middlewares/redis/limiter/limiter");

router.post("/",createLimit(5,30),firebase.verifyToken,favoriteApi.addItem);
router.get("/",firebase.verifyToken,favoriteApi.getAll)
router.delete("/:masp",firebase.verifyToken,favoriteApi.removeAt)


module.exports=router;

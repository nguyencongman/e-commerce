const cartController = require("../../controllers/api/cartAPI");
const express = require("express");
const router = express.Router();

router.post("/createCart", cartController.createCart);

module.exports=router;
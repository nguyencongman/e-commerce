const express=require("express");
const router=express.Router();
const sanphamController=require("../../controllers/api/sanphamAPI");
const api= require("../../controllers/api/bestSellersAPI")

router.get('/getProductsByType',sanphamController.getProductsByType)
router.get('/getProductByID',sanphamController.getProductByID)
router.get("/bestsellers",api.getItems);
router.get("/name",sanphamController.getProductByName)
router.get("/products",sanphamController.getAll)
module.exports= router
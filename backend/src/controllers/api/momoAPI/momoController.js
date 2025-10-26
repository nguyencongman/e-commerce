require("dotenv").config();
const express= require("express");
const app = express();
const crypto = require('crypto');
const order = require("../../../models/orderModels")
const order_items = require("../../../models/order_items");
const paymemt_controller = require("../../../models/paymentModel");


const createPayment =async (req,res)=>{
    const {amount,items}= req.body;
    const makh= req.uid;
    //https://developers.momo.vn/#/docs/en/aiov2/?id=payment-method
//parameters
var partnerCode = process.env.MOMO_PARTNER_CODE;
var accessKey =  process.env.MOMO_ACCESS_KEY;
var secretkey =  process.env.MOMO_SECRET_KEY;
var requestId = partnerCode + new Date().getTime();
var orderId = requestId;
var orderInfo = "pay with MoMo";
var redirectUrl =  process.env.MOMO_REDIRECT_URL;
var ipnUrl =  process.env.MOMO_IPN_URL;
// var ipnUrl = redirectUrl = "https://webhook.site/454e7b77-f177-4ece-8236-ddf1c26ba7f8";
var requestType = "captureWallet"
var extraData = ""; //pass empty value if your merchant does not have stores

//before sign HMAC SHA256 with format
//accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType
var rawSignature = "accessKey="+accessKey+"&amount=" + amount+"&extraData=" + extraData+"&ipnUrl=" + ipnUrl+"&orderId=" + orderId+"&orderInfo=" + orderInfo+"&partnerCode=" + partnerCode +"&redirectUrl=" + redirectUrl+"&requestId=" + requestId+"&requestType=" + requestType
//puts raw signature
console.log("--------------------RAW SIGNATURE----------------")
console.log(rawSignature)
//signature
var signature = crypto.createHmac('sha256', secretkey)
    .update(rawSignature)
    .digest('hex');
console.log("--------------------SIGNATURE----------------")
console.log(signature)

//json object send to MoMo endpoint
const requestBody = JSON.stringify({
    partnerCode : partnerCode,
    accessKey : accessKey,
    requestId : requestId,
    amount : amount,
    orderId : orderId,
    orderInfo : orderInfo,
    redirectUrl : redirectUrl,
    ipnUrl : ipnUrl,
    extraData : extraData,
    requestType : requestType,
    signature : signature,
    lang: 'vi'
});
//Create the HTTPS objects
const axios = require('axios');
const options = {
    method: 'POST',
    url:'https://test-payment.momo.vn/v2/gateway/api/create',
    headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(requestBody)
    },
    data:requestBody
}

try {

    var result = await axios(options);
    const dataPayment=result.data;

    //create order
    let date = new Date(dataPayment.responseTime);
      let infoOrDer={
        "order_id":dataPayment.orderId,
        "makh":makh,
        "amount_total":amount,
        "status":"pending",
        "create_at":date
      }
      await order.create(infoOrDer);      
      

      for(let item of items){
          let itemModel={
            "order_id":dataPayment.orderId,
            "masp":item.masp,
            "quantity":item.soluong,
            "size":item.size,
            "price_each":item.dongia,
            "subtotal":amount
          }
            await order_items.create(itemModel)

      }

    return res.status(200).json(dataPayment);
} catch (error) {
    return res.status(500).json({
        message:"server error",
        error:error.message
    })
}
}


const ipnCallback = async (req, res) => {
  console.log("callback received");
  const data = req.body;
  console.log({data})
   const rawSignature = 
  "accessKey=" + process.env.MOMO_ACCESS_KEY +
  "&amount=" + data.amount +
  "&extraData=" + data.extraData +
  "&message=" + data.message +
  "&orderId=" + data.orderId +
  "&orderInfo=" + data.orderInfo +
  "&orderType=" + data.orderType +
  "&partnerCode=" + data.partnerCode +
  "&payType=" + data.payType +
  "&requestId=" + data.requestId +
  "&responseTime=" + data.responseTime +
  "&resultCode=" + data.resultCode +
  "&transId=" + data.transId;


  const signature = crypto
    .createHmac("sha256", process.env.MOMO_SECRET_KEY)
    .update(rawSignature)
    .digest("hex");


  if (signature === data.signature) {
    if (Number(data.resultCode) === 0) {
      console.log("Payment success:");
      
    try {
      //create payment
      let paymentInfo={
        "order_id":data.orderId,
        "amount":data.amount,
        "payment_status":data.message,
        "momo_request_id":data.requestId,
        "momo_trans_id":data.transId,
        "payment_method":data.orderInfo
      }
      console.log({paymentInfo})
      await paymemt_controller.create(paymentInfo);

      //update status order

      await order.update(data.orderId)

        return res.status(201).json({ message: " payments success", resultCode: 0 });
    } catch (error) {
        return res.status(400).json({message:"insert order failed",error:error.message});
    }
    } else {
      console.log("Payment failed:");
      return res.status(200).json({ message: "payment failed", resultCode: data.resultCode });
    }
  } else {
    console.log("Invalid signature");
    return res.status(400).json({ message: "invalid signature" });
  }
};




module.exports={createPayment,ipnCallback}
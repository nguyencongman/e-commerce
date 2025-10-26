const express = require("express");
require("dotenv").config()
const app=express();
require("dotenv").config({path:"../.env"})
const cors = require("cors");

app.use(cors());
app.use(express.urlencoded({extended:true}))
app.use(express.json());
const session = require('express-session');


app.use(session({
  secret: 'secret123',
  resave: false,
  saveUninitialized: true
}));

app.use((req, res, next) => {
  res.locals.user = req.session.user || null;
  next();
});


const client=require("./config/redis/redis")
app.get("/redis",async (req,res)=> {
  const items = await client.hGetAll("cart:22")
  // const parseItems= Object.values(items).map((item)=>JSON.parse(item));
  const parseItems=Object.entries(items).map(([key,value])=>{
    parse=JSON.parse(value);
    return {field:key,value:parse}
  });
  res.send(parseItems);
})


// Biến toàn cục cho view 
app.use("/api/khachhang",require('./routes/apiRoutes/khachhangRoutes'))
app.use("/api/sanpham",require('./routes/apiRoutes/sanphamRoutes'))
app.use("/api/cart",require("./routes/apiRoutes/cartRoutes"))
app.use("/api/cartitem",require("./routes/apiRoutes/CartItemRoutes"))
app.use("/api/favorite",require("./routes/apiRoutes/favoriteRoutes"))
app.use("/api/momo",require("./routes/apiRoutes/momoRoutes"))


 

app.listen(3000,'0.0.0.0',(err)=>{
    if(err) throw err;
    console.log("http://localhost:3000")
})

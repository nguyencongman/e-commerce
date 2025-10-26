const redis = require('redis');
require("dotenv").config();
const client =  redis.createClient(
    {
       socket:{
         port:process.env.REDIS_PORT||6379,
        host:process.env.REDIS_HOST||'127.0.0.1'
       }
    }

);

client.on('connect',()=>{
     console.log("Redis connected");
})
client.on('error',(error)=>{
    console.log(`Redis Error ${error}`);
})
client.on('ready',()=>{
    console.log("Redis isready to use...")
})

client.connect().catch(err=>{
    console.error("Redis failed to connect",err);
})

module.exports=client
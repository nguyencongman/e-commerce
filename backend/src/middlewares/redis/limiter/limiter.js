  const client=require("../../../config/redis/redis")
 const createLimit= (limit,windowTime) => {
    return async (req,res,next) => {
        const key= `${req.ip}_${req.path}`;
        const request=await client.incr(key);
        var _ttl;
        if(request===1){
            await client.expire(key,windowTime);
            _ttl=windowTime
        }else{
            _ttl=await client.ttl(key);
        }

        if(request>limit){
            return res.status(429).json({message:` try again after ${_ttl}s`});
        }
        next();
}
}

module.exports={createLimit}

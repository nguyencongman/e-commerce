const client = require("../../config/redis/redis");
const favoriteModel= require("../../models/favoriteModel");

const  addItem = async (req,res) => {
    const {masp} = req.body;
    const makh=req.uid
    if(!makh){
        res.status(400).json({message:"Missing makh parameter"});
    }
    if(!masp){
        res.status(400).json({message:"Missing masp parameter"});
    }
    try {
        await favoriteModel.addItem(makh,masp);
        res.status(201).json({message:"Add favorite successs"});
    } catch (error) {
        res.status(500).json({message:error.message});
    }
}

const  removeAt = async (req,res) => {
    const masp = req.params.masp;
    const makh=req.uid;

    if(!makh){
        res.status(400).json({message:"Missing makh parameter"});
    }
    if(!masp){
        res.status(400).json({message:"Missing masp parameter"});
    }
    try {
        await favoriteModel.removeItem(makh,masp);
        res.status(200).json({message:"remove favorite successs"});
    } catch (error) {
        res.status(500).json({message:error.message});
    }
}
const getAll = async (req,res) => {
    const makh= req.uid;
   
    if(!makh){
       return res.status(400).json({message:"Missing makh parameter"});
    }
    const key = `favorite:${makh}`;
    const itemsRedis= await client.hGetAll(key);
    const list_id= Object.values(itemsRedis);
    console.log({itemsRedis,list_id,key})
    const items= await favoriteModel.getAll(list_id);

    return res.status(200).json({message:"get favorite items success",data:items});
}
module.exports={addItem,getAll,removeAt}
const client = require('../../config/redis/redis');
const cartModel = require('../../models/cartModel');
const sanphamModel=require("../../models/sanphamModel")
const getCartItem = async (req,res) => {
    try {
        const makh = req.uid;
         if (!makh) {
            return res.status(400).json({
                message: "Missing 'makh' parameter in getCartItem"
            });
        }
        
        //tra 1 object gom field va value
        const kq=await client.hGetAll(`cart:${makh}`)
        
        //tra ve 1 list cac item(value)
        var items=Object.entries(kq).map(([key ,val])=>{
            const item=JSON.parse(val);
            return item;
        })
        //tra 1 list masp
        const listId = items.map((i)=>i.masp)
        //lay danh sach san pham de gop vs cart ra itemcart
        const rows= await sanphamModel.getItemsByID(listId);

        //gộp item trong redis vs item trong sanpham
        const results = items.map((item)=>{
             const info= rows.find(row=>item.masp===row.masp );
             return{
                "masp":item.masp,
                "tensp":info.tensp,
                "dongia":item.dongia,
                "soluong":item.soluong,
                "thanhtien":item.thanhtien,
                "img":info.img,
                "size":item.size,
                "maloaisp":info.maloaisp
                
             }
        })

        return res.status(200).json({data:results})
        // const result = await cartModel.getCartItems2(makh);
        // if(result.length >0){
        //     return res.status(200).json({
        //         message:"get item in cart success",
        //         data:result
        //     });
        // }
        // else{
        //     return res.status(404).json({
        //         message:"no items found in cart"
        //     })
        // }
    } catch (error) {
        return res.status(500).json({
            message:"get item in cart failed",
            error:error.message
        })
    }
}


const removeItem = async (req,res) => {
    const {makh,masp} = req.query
    if(!masp){
        return res.status(400).json({message:"Missing masp parameter"})
    }
    else if(!makh){
        return res.status(400).json({message:"Missing makh parameter"})
    }
    try {
        await cartModel.removeItem2(makh,masp);
         return res.status(200).json({message:"item deleted",masp:masp});
    } catch (error) {
        res.status(404).json({message:error});
    }
}
const getMagiohang = async (req,res) => {
    const {makh}= req.query;
    if(!makh){
        return res.status(400).json({message:"Missing makh parameter"});
    }
    try {
        const magiohang=await cartModel.getMagiohang(makh);
        return res.status(200).json({message:"success",data:magiohang});
    } catch (error) {
        return res.status(404).json({message:error.message});
    }
}



const addOrUpdateItem= async (req,res) => {
    const item=req.body.item;
    const makh=req.uid;
    if(!item){
        return res.status(400).json({message:"Missing item parameter"})
    }
    try {
        await cartModel.addOrUpdateItem2(makh,item);
        return res.status(200).json({message:"add item ssuccess"})
    } catch (error) {
        return res.status(404).json({message:error.message})
    }
}

const increaseQuantityItem= async (req,res) => {
    const item=req.body.item;
    const makh=req.uid;
    if(!makh){
        return res.status(400).json({message:"Missing makh parameter  in increaseQuantityItem"})
    } 
    if(!item){
        return res.status(400).json({message:"Missing item parameter in increaseQuantityItem"})
    }
    try {
        await cartModel.increaseQuantityItem(makh,item);
        return res.status(200).json({message:"update quantity the item success"});
    } catch (error) {
        return res.status(500).json({message:error.message});
        
    }
}

const decreaseQuantityItem = async (req,res) => {
   const item=req.body.item;
    const makh=req.uid;
    if(!makh){
        return res.status(400).json({message:"Missing makh parameter  in decreaseQuantityItem"});
    }
     if(!item){
        return res.status(400).json({message:"Missing item parameter  in decreaseQuantityItem"});
    }
    try {
        await cartModel.decreaseQuantityItem(makh,item);
        return res.status(200).json({message:"update quantity the item success"});

    } catch (error) {
        return res.status(500).json({message:error.message});
    }
}

const deleteItem = async (req,res) => {
    const {masp,size}=req.query;
    const makh=req.uid;
    try {
        if(!makh){
        return res.status(400).json({message:"Missing makh parameter  in deleteItem"});
        }else if(!masp){
            return res.status(400).json({message:"Missing masp parameter  in deleteItem"});
        }else if(!size){
           return res.status(400).json({message:"Missing size parameter  in deleteItem"});
        }
        await cartModel.deleteItem(makh,masp,size);
        return res.status(200).json({message:"delete item success"});
        
    } catch (error) {
        return res.status(500).json({message:error.message})
    }
}
module.exports={
    getCartItem,removeItem,getMagiohang,addOrUpdateItem,increaseQuantityItem,decreaseQuantityItem,
    deleteItem
}
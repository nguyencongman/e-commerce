const sanphamModel=require("../../models/sanphamModel");

const getProductsByType= async(req,res)=>{
    try {
        const {category}=req.query
        const products = await sanphamModel.getProductsByType(category );
        return res.status(200).json({products:products,message:"getProductsByType Success"})
    } catch (error) {
         return res.status(400).json({error:error.message})   
    }
}
const getAll = async (req,res) => {
     try {
        const products = await sanphamModel.getAll();
        return res.status(200).json({data:products,message:"get All products Success"})
    } catch (error) {
         return res.status(500).json({error:error.message})   
    }
}

const getProductByID = async (req,res) => {
    try {
        const {id}= req.query
       const results = await sanphamModel.getProductByID(id);
       return res.status(200).json({product:results,message:"getProductById Success"});
    } catch (error) {
        return res.status(400).json({error:error.message})
    }
}

const getProductByName = async (req,res) => {
   try {
        const name = req.query.value;
        const names = await sanphamModel.getProductByName(name);
        return res.status(200).json({message:"success",data:names});
   } catch (error) {
        console.log(error)
        throw error;
   }
}

module.exports={getProductsByType,getProductByID,getProductByName,getAll}
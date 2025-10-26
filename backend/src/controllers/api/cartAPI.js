const cartModel = require("../../models/cartModel");

const createCart = async (req,res) => {
    try {
    const {makh} = req.body;
    const user=await cartModel.getCartByCustomer(makh);
    if(!user)
    {
        await cartModel.createCart(makh)
        return res.status(200).json({message:"add the cart success"})
    }
    return  res.status(200).json({message:"the customer had cart"});
   
    } catch (error) {
        return res.status(400).json({error:error.message})
    }
}
module.exports={createCart}
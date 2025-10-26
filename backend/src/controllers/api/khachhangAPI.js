const { sign } = require("jsonwebtoken");
const khachhang=require("../../models/khachhangModel");
const bcrypt=require("bcrypt")

// async function existingKhachHang(username) {
//     const result=await khachhang.findByUserName(username);
//     return result.length>0;
//  }

//  async function findByUserName(username) {
//     const result=await khachhang.findByUserName(username);
//     return result[0];
//  }


const signup = async (req,res)=>{
    try {
        const {name,email} = req.body;
        const uid=req.uid;
        if(!uid) return res.status(400).json({message:"missing uid parameter in signin"})
        if(!name)return res.status(400).json({message:"missing name parameter in signup"});    
        await khachhang.insertKhachHang(req.uid,email,name);
        return res.status(200).json({message:"Create user success"});
        
    } catch (error) {
          return  res.status(401).json({message:"signup failed",error:error.message})

    }
    
}

const signin = async(req,res)=>{
try {
    console.log("vao signup")
    const uid= "XXYmkbEE8rT8NHad1tTLLA6fdjw1";
    if(!uid) return res.status(400).json({message:"missing uid parameter in signin"})
     const user= await khachhang.findByuid (uid);
    if(!user||user.length===0){
       return res.status(400).json({message:"not found the user"});
    }
    return res.status(200).json({message:"signin success",user});
    
} catch (error) {
    return res.status(500).json({message:"signin failed",error:error.message});

}
}

const getCustomerById = async (req,res) => {
    try {
            const makh=req.uid;
            console.log({makh,uid:req.uid})
            if(!makh) return res.status(400).json({"message":"Missing makh parameter in getALLKhachHang "})
            const dsKhachHang= await khachhang.getCustomerById(makh);
            return res.status(200).json({"message":"get Customers success","data":dsKhachHang});
    } catch (error) {
        return res.status(500).json({
            "message":"get Customer failed",
            "error":error.message
        })
        
    }
}

const updateCustomer = async (req,res) => {
    const {hoten,dienthoai,diachi,email}= req.body;
    const makh =req.uid;
    try {
        if(!makh && !hoten && !dienthoai && !diachi && !email){
            return res.status(400).json({message:"Missing parameters in updateCustomer "});
        }
        await khachhang.updateCustomer(makh,hoten,dienthoai,diachi,email);
        return res.status(200).json({"message":"update customer success"});
    } catch (error) {
        return res.status(500).json({
            "message":"update customer failed",
            "error":error.message
        })
        
    }
}
module.exports={signup,signin,getCustomerById,updateCustomer}
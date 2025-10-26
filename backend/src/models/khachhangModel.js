const db= require("../config/mysql/mysql.js")
const findByUserName =  async (tendangnhap)=>{
   try {
    const sql="select * from khachhang where tendangnhap=?";
    const [result]= await db.query(sql,[tendangnhap]);
    return result;
   } catch (error) {
        console.log(error);
            return null;

   }
}

const findByuid =  async (uid)=>{
   try {
    const sql="select * from khachhang where makh=?";
    const [result]= await db.query(sql,[uid]);
    return result;
   } catch (error) {
        console.log(error);
            return null;

   }
}

const insertKhachHang = async(uid,email,name)=>{
    try {
        const sql='INSERT INTO KHACHHANG(makh,email,hoten) VALUES(?,?,?)';
         await db.query(sql,[uid,email,name]);
    } catch (error) {
      console.log(error);
    }
}

const getCustomerById= async (makh) => {
  const sql ='SELECT * FROM KHACHHANG WHERE MAKH =?';
  try {
    const [dsKhachHang] = await db.query(sql,[makh]);
    return dsKhachHang[0];
  } catch (error) {
    throw error;
  }
}
const updateCustomer = async (makh,hoten,dienthoai,diachi,email) => {
    const sql = 
    `UPDATE KHACHHANG
      SET HOTEN = ? , DIENTHOAI = ? , DIACHI = ? , EMAIL = ?
      WHERE MAKH =?
    `;
    try {
      await db.query(sql,[hoten,dienthoai,diachi,email,makh]);
    } catch (error) {
       throw(error);
    }
}


module.exports={findByUserName,insertKhachHang,getCustomerById,updateCustomer,findByuid}
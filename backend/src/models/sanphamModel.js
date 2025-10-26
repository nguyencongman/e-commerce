const db=require('../config/mysql/mysql.js')

const getAll = async()=>{
    try {
        const sql='SELECT* FROM SANPHAM';
        const [results]=await db.query(sql);
        return results;
    } catch (error) {
        console.log(error);
    }
}

const getProductsByType = async(category)=>{
    try {
        const sql=`SELECT *
         FROM sanpham join loaisanpham 
         ON sanpham.maloaisp=loaisanpham.maloaisp 
         WHERE loaisanpham.ten=?
         `
         const [results]= await db.query(sql,[category]);
         return results;
    } catch (error) {
        console.log(error);
    }
}
// Lấy thông tin sản phẩm theo ID
exports.getProductById = async (id) => {
  const [rows] = await db.query('SELECT * FROM sanpham WHERE masp = ?', [id]);
  return rows[0];
};

const getItemsByID = async (id) => {
  const [rows] = await db.query('SELECT * FROM sanpham WHERE masp in (?)', [id]);
  return rows;
};




const getProductByID = async (id) => {
    console.log(id)
  const [rows] = await db.query('SELECT * FROM sanpham WHERE masp = ?', [id]);
  return rows[0];
};


const getProductByName = async (name) => {
  try {
    const sql = `SELECT * from sanpham
              WHERE tensp LIKE  ?  `
    const [rows]=await db.query(sql,[`%${name}%`]);
  return rows; 
  } catch (error) {
    console.log(`error in getProductByName ${error}`);
  }
}



module.exports={getAll,getProductsByType,getProductByID,getItemsByID,getProductByName};

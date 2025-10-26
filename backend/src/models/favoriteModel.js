const client = require("../config/redis/redis");
const db = require("../config/mysql/mysql");

exports.addItem = async (makh,masp) => {
    const key = `favorite:${makh}`;
    const field=`${makh}_${masp}`
    if(!await client.hExists(key,field)){
       await client.hSet(key,field,masp);
    }
}

exports.removeItem =  async (makh,masp) => {
 const key = `favorite:${makh}`;
    const field=`${makh}_${masp}`
    if(await client.hExists(key,field)){
       await client.hDel(key,field);
    }
}

exports.getAll = async (list_masp) => {
   if(!list_masp||list_masp.length===0) return [];
   const sql ='select * from sanpham where masp in(?)';
   const [rows] =await db.query(sql,[list_masp]);
   return rows;
}
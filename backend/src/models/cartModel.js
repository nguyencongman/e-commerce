const { json } = require('body-parser');
const db = require('../config/mysql');
const client= require("../config/redis/redis")

exports.getCartByCustomer = async (makh) => {
    const [rows] = await db.query('select * from giohang where makh = ? and trangthai = 0 limit 1', [makh]);
    return rows[0];
};

exports.createCart = async (makh) => {
    const [result] = await db.query('insert into giohang(makh, ngaytao, trangthai) values(?, NOW(), ?)', [makh, 0]);
    return result.insertId;
};

exports.addOrUpdateItem = async (magiohang, masp, dongia) => {
    const [rows] = await db.query('select * from ctgiohang where magiohang = ? and masp = ?', [magiohang, masp]);
    if (rows.length > 0){
        await db.query(`
            update ctgiohang
            set soluong = soluong + 1, thanhtien = dongia * (soluong + 1)
            where magiohang = ? and masp = ?`, [magiohang, masp]);
    } else {
        await db.query('insert into ctgiohang(magiohang, masp, soluong, dongia, thanhtien) values(?, ?, 1, ?, ?)', [magiohang, masp, dongia, dongia]);
    }
};

exports.getCartItems = async (magiohang) => {
    const [rows] = await db.query('select sp.masp, sp.tensp, ct.soluong, ct.dongia, ct.thanhtien from ctgiohang ct join sanpham sp on sp.masp = ct.masp where magiohang = ?', [magiohang]);
    return rows;
}
exports.getCartItems2 = async (makh) => {
    try {
        const sql=`SELECT sp.masp,sp.tensp,ct.dongia,ct.soluong,ct.thanhtien,sp.img,ct.size,sp.maloaisp
                FROM giohang gh JOIN ctgiohang ct on gh.magiohang=ct.magiohang
                                                JOIN khachhang kh on gh.makh =kh.makh
                                                JOIN sanpham sp on ct.masp = sp.masp
                WHERE kh.makh=?`
         const [rows]=await db.query(sql,[makh]);
    return rows
    } catch (error) {
        throw error;
    }
}
exports.updateQty = async (magiohang, masp, delta) => {
    const [rows] = await db.query('select soluong from ctgiohang where magiohang = ? and masp = ?', [magiohang, masp]);
    if (rows.length > 0) {
        let newQty = rows[0].soluong + delta;
        if (newQty < 1) newQty = 1;
        await db.query('update ctgiohang set soluong = ?, thanhtien = dongia * ? where magiohang = ? and masp = ?', [newQty, newQty, magiohang, masp]);
    }
};

exports.removeItem = async (magiohang, masp) => {
    await db.query('delete from ctgiohang where magiohang = ? and masp = ?', [magiohang, masp]);
};

exports.removeItem2 = async (makh,masp) => {
    const sql =`DELETE ct
                FROM ctgiohang ct JOIN giohang gh on ct.magiohang=gh.magiohang
												JOIN	khachhang kh on kh.makh=gh.makh 
                WHERE ct.masp=? and kh.makh=?
                `;
    await db.query(sql,[masp,makh]);
}

exports.getMagiohang = async (makh) => {
    sql=`SELECT magiohang
        from giohang
        WHERE makh=?`
    const [magiohang]= await db.query(sql,[makh]);
    return magiohang[0];
}


 item={
    magiohang:0,
    masp:0,
    dongia:0,
    soluong:0,
    thanhtien:0,
    size:""
};



exports.increaseQuantityItem= async (makh,item) => {
    var key = `cart:${makh}`;
    var field= `${item.masp}_${item.size}`;
    var itemmRedis= await client.hGet(key,field);
    var parseItem= JSON.parse(itemmRedis);
    parseItem.soluong+=1;
    parseItem.thanhtien=parseItem.soluong*parseItem.dongia

    await client.hSet(key,field,JSON.stringify(parseItem));
}

exports.decreaseQuantityItem = async (makh,item) => {
    const key = `cart:${makh}`;
    const field = `${item.masp}_${item.size}`;

    const itemRedis = await client.hGet(key,field);
    var parseItem= JSON.parse(itemRedis);
    if(parseItem.soluong<=1){
        parseItem.soluong=1;
        return
    }
    parseItem.soluong-=1;
    parseItem.thanhtien=parseItem.soluong*parseItem.dongia
    await client.hSet(key,field,JSON.stringify(parseItem));
}

exports.deleteItem = async (makh,masp,size) => {
    const key =  `cart:${makh}`;
    const field =  `${masp}_${size}`;
    await client.hDel(key,field);
}







exports.addOrUpdateItem2 = async (makh,item) => {

    var key=`cart:${makh}`
    var field=`${item.masp}_${item.size}`
    var value ={
        masp: item.masp,
        soluong: 1,
        dongia: item.dongia,
        thanhtien: item.thanhtien,
        size:item.size
    };

    if(await client.hExists(key,field)){
        var itemm = await client.hGet(key,field);
        var parseItem=JSON.parse(itemm)
        value.soluong= parseItem.soluong+1
        value.thanhtien=parseItem.dongia*value.soluong
        
    }
    await client.hSet(key,field,JSON.stringify(value));
    // const [rows] = await db.query('select * from ctgiohang where magiohang = ? and masp = ?', [item.magiohang, item.masp]);
    // if (rows.length > 0){
    //     await db.query(`
    //         update ctgiohang
    //         set soluong = soluong + 1, thanhtien = dongia * soluong
    //         where magiohang = ? and masp = ?`, [item.magiohang, item.masp]);
    // } else {
    //     await db.query('insert into ctgiohang(magiohang, masp, soluong, dongia, thanhtien,size) values(?, ?, 1, ?, ?,?)', [item.magiohang, item.masp, item.dongia, item.dongia,item.size]);
    // }    
};







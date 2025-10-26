const db = require("../config/mysql/mysql");


exports.create = async (data) => {
    try {
        const sql = "insert into order_items(order_id,masp,quantity,size,price_each,subtotal) values(?,?,?,?,?,?)";
         await db.query(sql,[data.order_id,data.masp,data.quantity,data.size,data.price_each,data.subtotal]);
    } catch (error) {
        console.log(`insert cthdbanhang error ${error}`);
        throw error;
    }
}

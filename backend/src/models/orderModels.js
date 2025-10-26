const db = require("../config/mysql/mysql");


exports.create = async (data) => {
    try {
        const sql = "insert into orders(order_id,makh,amount_total,status,created_at) values(?,?,?,?,?)";
       const [result]=  await db.query(sql,[data.order_id,data.makh,data.amount_total,data.status,data.create_at]);
        return result.insertId
    } catch (error) {
        console.log(error);
        throw error;
    }
}

exports.update = async (order_id) => {
    try {
        const sql = "update orders set status = ? where order_id=? ";
         await db.query(sql,['paid',order_id]);
    } catch (error) {
        console.log(error);
        throw error;
    }
}


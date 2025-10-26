const db = require("../config/mysql/mysql")
exports.create = async (paymentData) => {
    try {
        const sql = `INSERT INTO payments(order_id,amount,payment_status,momo_request_id,momo_trans_id,payment_method)
                    VALUES(?,?,?,?,?,?)`
        await db.query(sql,[
            paymentData.order_id,
            paymentData.amount,
            paymentData.payment_status,
            paymentData.momo_request_id,
            paymentData.momo_trans_id,
            paymentData.payment_method,

        ]);
        //return res.status(201).json({"messege":"insert payments success"}); 
        
    } catch (error) {
        console.log(error.message);
        throw error;
       // return res.status(500).json({error:error})
    }
    
}
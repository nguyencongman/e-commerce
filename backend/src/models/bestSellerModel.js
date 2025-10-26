const database = require("../config/mysql/mysql");

exports.getItems = async () => {
    const sql =` SELECT  SUM(c.quantity) as soluong,c.masp ,s.tensp,s.img,s.dongia,s.maloaisp
                    from order_items c  JOIN sanpham s on s.masp=c.masp
                    GROUP BY c.masp
                    ORDER BY SUM(c.quantity) DESC
                    LIMIT 5`
    try {
        const [result]= await database.query(sql);
        if(result)return result
        return []
    } catch (error) {
        console.log(`error in bestSellersAPI/getItems: ${error}`);
        throw error;
    }
    
}
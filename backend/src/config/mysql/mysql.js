const mysql = require("mysql2/promise"); 
const path = require("path");
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

const pool = mysql.createPool({
  host: process.env.HOST_DB,
  user: process.env.USERNAME_DB,
  password: process.env.PASSWORD_DB,
  database: process.env.NAME_DB,
                      
});

 (async () => {
  try {
    const connection = await pool.getConnection(); 
    console.log(" Kết nối MySQL thành công");
    connection.release(); 
  } catch (err) {
    console.log("DB:", process.env.USERNAME_DB); // phải in ra "root"

    console.error(" Kết nối MySQL thất bại:", err.message);
  }
})();
module.exports = pool;

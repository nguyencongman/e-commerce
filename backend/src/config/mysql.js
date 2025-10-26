const mysql = require('mysql2/promise'); // ← Dùng bản promise

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'quan_ly_ban_hang'
});

module.exports = pool;

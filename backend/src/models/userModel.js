const db = require('../config/mysql');

// Tìm người dùng theo email và password
exports.findByEmailAndPassword = async (tendangnhap, password) => {
  const [rows] = await db.query(
    'SELECT * FROM khachhang WHERE tendangnhap = ? AND password = ?',[tendangnhap, password]);
  return rows[0];
};

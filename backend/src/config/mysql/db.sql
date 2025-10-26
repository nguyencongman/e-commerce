CREATE DATABASE quan_ly_ban_hang;
USE quan_ly_ban_hang;

CREATE TABLE sanpham (
    masp INT AUTO_INCREMENT PRIMARY KEY,
    tensp VARCHAR(255),
    maloaisp INT,
    soluong INT,
    mota TEXT,
    dongia DECIMAL(18, 2),
    tinhtrang INT,
    xuatxu VARCHAR(50),
    chatlieu VARCHAR(50),
    mausac VARCHAR(50),
    img VARCHAR(255),
    trangthai INT
);

CREATE TABLE nhanvien (
    tendangnhap VARCHAR(30) PRIMARY KEY,
    matkhau VARCHAR(250),
    hoten VARCHAR(50),
    email VARCHAR(30),
    diachi TEXT,
    dienthoai VARCHAR(20),
    ngaysinh DATE,
    gioitinh BOOLEAN,
    chucvu VARCHAR(20),
    trangthai VARCHAR(20)
);

CREATE TABLE khachhang (
    makh INT AUTO_INCREMENT PRIMARY KEY,
    tendangnhap VARCHAR(50),
    matkhau VARCHAR(250)
    hoten VARCHAR(50),
    diachi TEXT,
    dienthoai VARCHAR(20),
    ngaysinh DATE,
    gioitinh BOOLEAN,
    trangthai INT
);

CREATE TABLE hdnhaphang (
    maHoaDonNhap INT AUTO_INCREMENT PRIMARY KEY,
    ngaynhap DATE,
    manv VARCHAR(30),
    mancc INT,
    tongtien DECIMAL(18, 2),
    trangthai INT
);

CREATE TABLE nhacungcap (
    mancc INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(255),
    website VARCHAR(50),
    email VARCHAR(50),
    dienthoai VARCHAR(20),
    diachi TEXT,
    trangthai INT
);

CREATE TABLE cthdnhaphang (
    maHoaDonNhap INT,
    masp INT,
    soluong INT,
    dongia DECIMAL(18, 2),
    thanhtien DECIMAL(18, 2),
    trangthai INT,
    PRIMARY KEY (maHoaDonNhap, masp)
);

CREATE TABLE loaisanpham (
    maloaisp INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(50),
    trangthai INT
);

CREATE TABLE hdbanhang (
    mahd INT AUTO_INCREMENT PRIMARY KEY,
    ngayban DATE,
    manv VARCHAR(30),
    makh INT,
    tongtien DECIMAL(18, 2),
    trangthai BOOLEAN
);

CREATE TABLE cthdbanhang (
    mahd INT,
    masp INT,
    soluong INT,
    dongia DECIMAL(18, 2),
    thanhtien DECIMAL(18, 2),
    giamgia DECIMAL(18, 2),
    loaigiam VARCHAR(10),
    trangthai BOOLEAN,
    PRIMARY KEY (mahd, masp)
);


-- Tạo bảng giỏ hàng
CREATE TABLE giohang (
    magiohang INT AUTO_INCREMENT PRIMARY KEY,
    makh INT,
    ngaytao DATETIME DEFAULT CURRENT_TIMESTAMP,
    trangthai BOOLEAN DEFAULT 0,
    CONSTRAINT FK_giohang_khachhang FOREIGN KEY (makh) REFERENCES khachhang(makh)
);

-- Tạo bảng chi tiết giỏ hàng
CREATE TABLE ctgiohang (
    magiohang INT,
    masp INT,
    soluong INT,
    dongia DECIMAL(18,2),
    thanhtien DECIMAL(18,2),
    PRIMARY KEY (magiohang, masp),
    CONSTRAINT FK_ctgiohang_giohang FOREIGN KEY (magiohang) REFERENCES giohang(magiohang),
    CONSTRAINT FK_ctgiohang_sanpham FOREIGN KEY (masp) REFERENCES sanpham(masp)
);

-- Các khóa ngoại

ALTER TABLE hdbanhang
ADD CONSTRAINT FK_hdbanhang_khachhang FOREIGN KEY (makh) REFERENCES khachhang(makh);

ALTER TABLE hdbanhang
ADD CONSTRAINT FK_hdbanhang_nhanvien FOREIGN KEY (manv) REFERENCES nhanvien(tendangnhap);

ALTER TABLE cthdbanhang
ADD CONSTRAINT FK_cthdbanhang_hdbanhang FOREIGN KEY (mahd) REFERENCES hdbanhang(mahd);

ALTER TABLE cthdbanhang
ADD CONSTRAINT FK_cthdbanhang_sanpham FOREIGN KEY (masp) REFERENCES sanpham(masp);

ALTER TABLE sanpham
ADD CONSTRAINT FK_sanpham_loaisanpham FOREIGN KEY (maloaisp) REFERENCES loaisanpham(maloaisp);

ALTER TABLE hdnhaphang
ADD CONSTRAINT FK_hdnhaphang_nhanvien FOREIGN KEY (manv) REFERENCES nhanvien(tendangnhap);

ALTER TABLE hdnhaphang
ADD CONSTRAINT FK_hdnhaphang_nhacungcap FOREIGN KEY (mancc) REFERENCES nhacungcap(mancc);

ALTER TABLE cthdnhaphang
ADD CONSTRAINT FK_cthdnhaphang_hdnhaphang FOREIGN KEY (maHoaDonNhap) REFERENCES hdnhaphang(maHoaDonNhap);

ALTER TABLE cthdnhaphang
ADD CONSTRAINT FK_cthdnhaphang_sanpham FOREIGN KEY (masp) REFERENCES sanpham(masp);

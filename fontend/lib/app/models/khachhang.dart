class KhachHang{
  final String hoten;
  final String diachi;
  final String dienthoai;
  final String email;
  final int trangthai;


  const KhachHang({
    required this.hoten,
    required this.diachi,
    required this.dienthoai,
    required this.email,
    required this.trangthai,

  });

 factory KhachHang.fromJson(Map<String,dynamic> json){
    return KhachHang(
        hoten: json["hoten"]??"no name",
        diachi: json["diachi"] ??"",
        dienthoai: json["dienthoai"]??"",
        email: json["email"]??"",
        trangthai: json["trangthai"]??0,

    );
  }
  Map<String,dynamic> toJson(){
      return {
        "hoten": this.hoten,
        "diachi": this.diachi,
        "dienthoai": this.dienthoai,
        "email": this.email,
        "trangthai":this.trangthai,

      };
  }
  @override
  String toString() {
    // TODO: implement toString
    return "KhachHang(hoten:${this.hoten}, email:${this.email})";
  }


}
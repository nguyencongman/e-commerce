class SanPhamModel {
 final int masp;
 final String tensp;
 final int maloaisp;
 final int soluong;
 final String mota;
 final double dongia;
 final int tinhtrang;
 final String xuatxu;
 final String chatlieu;
 final String mausac;
 final String img;
 final int trangthai;

 const SanPhamModel({
    required this.masp,
    required this.tensp,
    required this.maloaisp,
    required this.soluong,
    required this.mota,
    required this.dongia,
    required this.tinhtrang,
    required this.xuatxu,
    required this.chatlieu,
    required this.mausac,
    required this.img,
    required this.trangthai,
  });
 factory SanPhamModel.fromJson(Map<String,dynamic> json){
    return SanPhamModel(
      masp: int.tryParse(json['masp'].toString()) ?? 0,
      tensp: json['tensp']?.toString() ?? 'empty',
      maloaisp: int.tryParse(json['maloaisp'].toString()) ?? 0,
      soluong: int.tryParse(json['soluong'].toString()) ?? 0,
      mota: json['mota']?.toString() ?? 'empty',
      dongia: double.tryParse(json['dongia'].toString()) ?? 0.0,
      tinhtrang: int.tryParse(json['tinhtrang'].toString()) ?? 1,
      xuatxu: json['xuatxu']?.toString() ?? 'empty',
      chatlieu: json['chatlieu']?.toString() ?? 'empty',
      mausac: json['mausac']?.toString() ?? 'empty',
      img: json['img']?.toString() ?? 'empty',
      trangthai: int.tryParse(json['trangthai'].toString()) ?? 1,
    );
 }

 @override
  String toString() {
    // TODO: implement toString
    return "Model("
        "masp : ${masp}, "
        // "tensp : ${tensp}, "
        // "dongia : ${dongia}, "
        // "mota : ${mota}, "
        // "img : ${img}, "
        ")";
  }

}

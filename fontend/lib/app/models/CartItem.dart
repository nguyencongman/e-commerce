import 'package:get/get.dart';

class CartItems {
  final int masp;
  final String tensp;
  final double dongia;
  final int soluong;
  final double thanhtien;
  final String img;
  final String size;
  final int maloaisp;
  Rx<bool> isCheck = false.obs;

  factory CartItems.FromJson(Map<String, dynamic> json) {
    return CartItems(
        masp: json['masp'] ?? 0,
        tensp: json['tensp'] ?? "none",
        dongia: double.tryParse(json['dongia'].toString()) ?? 0.0,
        soluong: json['soluong'] ?? 0,
        thanhtien: double.tryParse(json['thanhtien'].toString()) ?? 0.0,
        img: json['img'] ?? "none",
        size: json['size'] ?? "none",
        maloaisp: int.tryParse(json['maloaisp'].toString()) ?? 0);
  }

  Map<String, dynamic> ToJson() {
    return {
      "masp": masp,
      "tensp": tensp,
      "dongia": dongia,
      "soluong": soluong,
      "thanhtien": thanhtien,
      "img": img,
      "size": size,
      "maloaisp": maloaisp
    };
  }

  @override
  String toString() {
    return 'CartItem( tensp $tensp, isCheck ${isCheck.value})';
  }

  CartItems({
    required this.masp,
    required this.tensp,
    required this.dongia,
    required this.soluong,
    required this.thanhtien,
    required this.img,
    required this.size,
    required this.maloaisp,
  });
}

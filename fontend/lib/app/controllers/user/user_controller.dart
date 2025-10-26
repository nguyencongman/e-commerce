import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/models/khachhang.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  RxString userId = "".obs;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Rx<KhachHang> khachhang = const KhachHang(
          hoten: "", diachi: "", dienthoai: "", email: "", trangthai: 1)
      .obs;

  Future<void> loadData() async {
    final results = await getCustomerById();
    khachhang.value = results;
    nameController.text = khachhang.value.hoten;
    phoneController.text = khachhang.value.dienthoai;
    emailController.text = khachhang.value.email;
  }

  final auth = Get.find<AuthService>();
  Future<bool> updateCustomer() async {
    final url = Uri.parse("${ApiConstants.baseUrl}/khachhang");
    final tokenId = await auth.getIdToken();
    try {
      final response = await http.put(url,
          headers: {
            "content-type": "application/json",
            "authorization": "Bearer $tokenId"
          },
          body: jsonEncode({
            "hoten": nameController.value.text,
            "dienthoai": phoneController.value.text,
            "diachi": addressController.value.text,
            "email": emailController.value.text
          }));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("success", data["message"]);
        loadData();
        isLoading.value = false;
        return true;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<KhachHang> getCustomerById() async {
    final tokenId = await auth.getIdToken();
    final url = '${ApiConstants.baseUrl}/khachhang/makh';
    try {
      final response = await http
          .get(Uri.parse(url), headers: {"authorization": "Bearer $tokenId"});

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return KhachHang.fromJson(data["data"]);
      }
      throw data['message'];
    } catch (e) {
      throw Exception({
        "message": "Failed getCustomerById : ${e.toString()}",
      });
    }
  }
}

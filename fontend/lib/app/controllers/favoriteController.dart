import 'dart:convert';

import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/models/sanpham.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoriteController extends GetxController {
  RxList<SanPhamModel> items = <SanPhamModel>[].obs;
  final AuthService auth = Get.find<AuthService>();

  Future<void> loadData() async {
    List<SanPhamModel> results = await getAll();
    items.value = results;
  }

  Future<List<SanPhamModel>> getAll() async {
    final tokenId = await auth.getIdToken();
    if (tokenId == null || tokenId.isEmpty) {
      Get.snackbar("Failed", "Unauthorized");
      return [];
    }
    final url = Uri.parse("${ApiConstants.baseUrl}/favorite");
    final response =
        await http.get(url, headers: {'authorization': "Bearer $tokenId"});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> items = data['data'];
      return items.map((item) => SanPhamModel.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception("get favorite items failed");
    }
  }

  Future<bool> addItem(int masp) async {
    final tokenId = await auth.getIdToken();
    final url = Uri.parse("${ApiConstants.baseUrl}/favorite");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer $tokenId"
        },
        body: jsonEncode({"masp": masp}));

    try {
      if (response.statusCode == 201) {
        loadData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> remove(int masp) async {
    final tokenId= await auth.getIdToken();
    final url = Uri.parse(
        "${ApiConstants.baseUrl}/favorite/$masp");
    final response = await http.delete(url,headers: {"authorization":"Bearer $tokenId"});
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar("success", data['message']);
        loadData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

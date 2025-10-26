import 'dart:convert';

import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/models/sanpham.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SanPhamController extends GetxController {
  RxString selectedCategory = "coffee".obs;
  var categoryProducts = <SanPhamModel>[].obs;
  List<SanPhamModel> all_Products = [];
  List<SanPhamModel> bestSeller_items = [];
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    List<SanPhamModel> result =
        await fetchProductByType(selectedCategory.value);
    categoryProducts.value = result;
    bestSeller_items = await fetchBestsellers();
    all_Products = await fetchProducts();
  }

  Future<List<SanPhamModel>> fetchProducts() async {
    final response =
        await http.get(Uri.parse("${ApiConstants.baseUrl}/sanpham/products"));
    final json = jsonDecode(response.body);
    final List<dynamic> data = json['data'];
    if (response.statusCode == 200) {
      return data.map((e) => SanPhamModel.fromJson(e)).toList();
    } else {
      throw Exception("loi");
    }
  }

  Future<List<SanPhamModel>> fetchProductByType(String category) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/sanpham/getProductsByType?category=${category}');
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final List<dynamic> listProducts = json['products'];
    if (response.statusCode == 200) {
      return listProducts.map((e) => SanPhamModel.fromJson(e)).toList();
    } else {
      throw Exception("Error in field fetchProductByType");
    }
  }

  Future<SanPhamModel> fetchProductById(int id) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/sanpham/getProductByID?id=$id');
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final SanPhamModel sanpham = SanPhamModel.fromJson(json['product']);
    return sanpham;
  }

  Future<List<SanPhamModel>> fetchBestsellers() async {
    const url = "${ApiConstants.baseUrl}/sanpham/bestsellers";
    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      List<dynamic> data = json['data'];
      if (response.statusCode == 200) {
        final items = data.map((e) => SanPhamModel.fromJson(e)).toList();
        return items;
      }
      return [];
    } catch (e) {
      throw e;
    }
  }
}

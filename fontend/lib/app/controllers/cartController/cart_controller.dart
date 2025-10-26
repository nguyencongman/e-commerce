import 'dart:convert';
import 'package:e_commerce/app/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  RxInt IdCart = 0.obs;
  Future<bool> createCart(String id) async {
    try {
      final uri = Uri.parse('http://10.0.2.2:3000/api/cart/createCart');
      await http.post(uri, body: {"makh": id});
      IdCart.value = await getIdCart(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getIdCart(String makh) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}/cartitem/getMaGioHang?makh=$makh');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['magiohang'];
      }
    } catch (e) {
      throw "getidcart $e";
    }
    return 0;
  }
}

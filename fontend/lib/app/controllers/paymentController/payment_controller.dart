import 'dart:convert';

import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  Future<String> CreateOrder(
      List<Map<String, dynamic>> items, double price) async {
    final tokenId = await _auth.getIdToken();
    const url = '${ApiConstants.baseUrl}/momo/createPayment';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "authorization": "Bearer $tokenId"
        },
        body: jsonEncode({
          'amount': price,
          'items': items,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['deeplink'];
      }
      return data['deeplink'];
    } catch (e) {
      throw e.toString();
    }
  }
}

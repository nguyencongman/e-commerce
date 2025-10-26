import 'dart:convert';
import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/controllers/user/user_controller.dart';
import 'package:e_commerce/app/models/CartItem.dart';
import 'package:e_commerce/app/models/DetailsItem.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Cartitemcontroller extends GetxController {
  RxList<CartItems> items = <CartItems>[].obs;
  List<CartItems> get checkedItems =>
      items.where((item) => item.isCheck.value).toList();
  final auth = Get.find<AuthService>();

  //quan ly nut bam tranh tinh trang spa, tra ve 429 thi set false
  bool isActive = true;

  final userController = Get.find<UserController>();

  double total() {
    double total = 0;
    for (var element in checkedItems) {
      total += (element.thanhtien);
    }
    return total;
  }

  void checkAll(bool value) {
    for (var item in items) {
      item.isCheck.value = value;
    }
  }

  Future<void> loadData() async {
    final results = await getCartItem();
    //tao 1 map de giu danh sach cu
    final oldData = {for (var e in items) '${e.masp}_${e.size}': e};

    items.clear();
    //kiem tra  map co chua item k , neu co thi set ischeck trang trai cu.
    for (var item in results) {
      final key = '${item.masp}_${item.size}';
      if (oldData.containsKey(key)) {
        item.isCheck.value = oldData[key]!.isCheck.value;
      }
    }
    // map.containsKey !!! qua manh.

    items.value = results;
  }

  void loadDateRemove() async {
    List<CartItems> results = await getCartItem();
    items.value = results;
  }

  Future<List<CartItems>> getCartItem() async {
    final tokenId = await auth.getIdToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/cartitem');
    final response =
        await http.get(url, headers: {"authorization": "Bearer $tokenId"});
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['data'] != null) {
      final List<dynamic> fetchedItems = data['data'];
      return fetchedItems.map((item) => CartItems.FromJson(item)).toList();
    } else {
      return [];
    }
  }

  Future<bool> removeItem(int masp) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/cartitem/removeItem?makh=${userController.userId}&masp=$masp');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.snackbar("success", data['message']);
      loadData();
      return true;
    }
    Get.snackbar("failed", data['message']);
    return false;
  }

  Future<bool> addItem(detailsItem item) async {
    final tokenId = await auth.getIdToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/cartitem');
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          "authorization": "Bearer $tokenId"
        },
        body: jsonEncode({"item": item.tojson()}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.snackbar("Success", data['message']);
      loadData();
      return true;
    }
    Get.snackbar("Failed", data['message']);
    return false;
  }

  Future<bool> increaseQuantityItem(detailsItem item) async {
    final tokenId = await auth.getIdToken();

    final url =
        Uri.parse('${ApiConstants.baseUrl}/cartitem/increaseQuantityItem');
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          "authorization": "Bearer $tokenId"
        },
        body: jsonEncode({"item": item.tojson()}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      loadData();
      isActive = true;
      return true;
    } else if (response.statusCode == 429) {
      if (!isActive) {
        return false;
      }
      isActive = false;
      Get.snackbar("Server is busy", data['message']);
      return false;
    } else {
      Get.snackbar("Failed", data['message']);
      return false;
    }
  }

  Future<bool> decreaseQuantityItem(detailsItem item) async {
    final tokenId = await auth.getIdToken();

    final url =
        Uri.parse('${ApiConstants.baseUrl}/cartitem/decreaseQuantityItem');
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          "authorization": "Bearer $tokenId"
        },
        body: jsonEncode({"item": item.tojson()}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      isActive = true;
      loadData();
      return true;
    } else if (response.statusCode == 429) {
      if (!isActive) {
        return false;
      }
      isActive = false;
      Get.snackbar("Server is busy", data['message']);
      return false;
    } else {
      Get.snackbar("Failed", data['message']);
      return false;
    }
  }

  Future<bool> deleteItem(int masp, String size) async {
    final tokenId = await auth.getIdToken();

    final url = Uri.parse('${ApiConstants.baseUrl}/cartitem?'
        'masp=${masp}&size=${size}');
    final response = await http.delete(url,headers: {
      "authorization": "Bearer $tokenId"
    });
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.snackbar("Success", data['message']);
      loadData();
      return true;
    }
    Get.snackbar("Failed", data['message']);
    return false;
  }
}

import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/controllers/cartController/cart_item_controller.dart';
import 'package:e_commerce/app/controllers/chat/chatService.dart';
import 'package:e_commerce/app/controllers/favoriteController.dart';
import 'package:e_commerce/app/controllers/user/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../cartController/cart_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final userController = Get.find<UserController>();
  final cartController = Get.find<CartController>();
  final cartItemController = Get.find<Cartitemcontroller>();
  final favoriteController = Get.find<FavoriteController>();
  final chatService = Get.find<ChatService>();

  RxString text = "".obs;
  RxString name = "".obs;
  RxBool isLoading = false.obs;
  bool isActive = true;

  final AuthService _auth = Get.find();

  Future<bool> fetchAccount() async {
    isLoading.value = true;
    try {
      //call signWithEmailandPassword to Firebase
      final userCredential = await _auth.signIn(
          emailController.value.text.trim(),
          passwordController.value.text.trim());
      //get user from userCredential
      final user = userCredential.user;

      if (user != null) {
        // get token from current user
        final validate = await _auth
            .authWithServer("${ApiConstants.baseUrl}/khachhang/signin");

        if (validate == true) {
          isActive = true;
          userController.userId.value = user.uid;

          await Future.wait<void>([
            userController.loadData(),
            cartItemController.loadData(),
            favoriteController.loadData(),
          ]);
          name.value = user.displayName ?? user.email ?? "";
          text.value = "";
          Get.snackbar("Login Successful", "Welcome ${name.value}");
          return true;
        } else {
          Get.snackbar("Login failed", "Server validation failed");
          return false;
        }
      } else {
        Get.snackbar("Login Failed", "User not found");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      text.value = e.message ?? "";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

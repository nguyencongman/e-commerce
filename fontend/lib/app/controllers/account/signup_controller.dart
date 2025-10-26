import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final userController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final nameController = TextEditingController().obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<String> text = "".obs;
  RxBool isLoading = false.obs;
  final AuthService _auth = Get.find();
  Future<bool> signupAccount() async {
    isLoading.value = true;
    try {
      final credentail = await _auth.signUp(
          userController.value.text, passwordController.value.text);
      final user = credentail.user;
      if (user != null) {
        final validate = await _auth
            .authWithServer('${ApiConstants.baseUrl}/khachhang', userInfo: {
          "name": nameController.value.text,
          "email": userController.value.text
        });

        if (validate == true) {
          await firestore.collection("Users").doc(user.uid).set({
            "uid": user.uid,
            "email": userController.value.text,
          });
          userController.value.clear();
          nameController.value.clear();
          passwordController.value.clear();

          Get.snackbar("success", "Please login the app");
          text.value = "";
          return true;
        } else {
          Get.snackbar("Failed", 'Server validate fail');
          return false;
        }
      } else {
        Get.snackbar("Failed", "");
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

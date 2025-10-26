import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> sendPassWord(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Failed", e.message ?? "");
      print("error sending password: $e");
      return false;
    } catch (e) {
      print("error in sendPassWord : $e");
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print("Error signout ${e}");
    }
  }

  Future<String?> getIdToken() async {
    final user = auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<bool> authWithServer(String url,
      {Map<String, dynamic>? userInfo}) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return false;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $idToken'
        },
        body: userInfo != null ? jsonEncode(userInfo) : null,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw e.toString();
    }
  }
}

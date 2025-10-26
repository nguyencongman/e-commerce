import 'package:shared_preferences/shared_preferences.dart';

class SharedPres {
  static Future<String> getReceiverEmail() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("email") ?? "nodata";
  }

  static Future<String> getReceiverUid() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("uid") ?? "nodata";
  }

  static Future<void> setReceiverUid(String uid) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", uid);
  }

  static Future<void> setReceiverEmail(String email) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("email", email);
  }
}

import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/view/widgets/TextField.dart';
import 'package:e_commerce/utils/constants/FormatText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassWord extends StatelessWidget {
  ForgotPassWord({super.key});
  final _controller = TextEditingController();
  final _auth = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText.TextTitle("Forgot password"),
              const Text("Please enter your email to reset the password"),
              FText.TextLabel("Your email"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldV2(
                    controller: _controller, label: "Enter your email"),
              ),
              Submit()
            ],
          ),
        ));
  }

  Widget Submit() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          child: TextButton(
              onPressed: () async {
                final result = await _auth.sendPassWord(_controller.value.text);
                if (result == true) {
                  Get.back();
                  Get.snackbar(
                      "Success", "we sent the reset password in your email");
                }
              },
              child: Text(
                "Verify code",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}

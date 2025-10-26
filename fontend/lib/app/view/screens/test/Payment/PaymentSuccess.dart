import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: Get.height/5,
                  child: Image(image:AssetImage('images/payment/success-icon.png')),),
                SizedBox(height: 30,),
                Text(
                  "Success",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Get.offNamed('/mainScreen');
                },
                child: Text(
                  "Back!",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                ))
          ],
        ),
      )),
    );
  }
}

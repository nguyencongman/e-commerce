import 'package:e_commerce/utils/constants/FormatText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserChat extends StatefulWidget {
  UserChat({super.key, this.uid, this.email});
  String? uid;
  String? email;

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FText.TextTitle("Chủ Xốp"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

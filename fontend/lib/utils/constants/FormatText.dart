import 'package:flutter/cupertino.dart';

class FText {
  static Widget TextTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "${title}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget TextLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style:const  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

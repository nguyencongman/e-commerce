import 'package:e_commerce/utils/constants/FormatText.dart';
import 'package:flutter/material.dart';

class Mybutton {
  static Widget Button(
      {required BuildContext context,
      required VoidCallback onTap,
      required String text,
      required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FText.TextTitle(text),
          ),
        ),
      ),
    );
  }
}

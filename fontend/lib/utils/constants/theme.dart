import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class appColors{
  static const Color lightText=Colors.black;
  static const Color dartText=Colors.white;
  static Color lightTitle=Colors.blue[900]!;
  static Color darkTitle = Colors.blue[200]!;
  static const Color backgroundLight=Colors.white;
  static const Color backgroundDart=Colors.black54;

}
class appTheme{
  static ThemeData get lightTheme{
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: appColors.backgroundLight,
      );
  }
  static ThemeData get darkTheme{
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: appColors.backgroundDart,
    );
  }
}
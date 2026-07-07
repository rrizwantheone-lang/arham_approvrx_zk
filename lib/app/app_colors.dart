import 'package:flutter/material.dart';

/// All app colors are defined here
class AppColors {
  AppColors._();

  // Purple color shades for your theme
  static const MaterialColor teal = MaterialColor(
    _tealPrimaryValue, // Primary color for MaterialColor (Purple 500)
    <int, Color>{
      50: Color(0xFFE0F2F1),
      100: Color(0xFFB2DFDB),
      200: Color(0xFF80CBC4),
      300: Color(0xFF4DB6AC),
      400: Color(0xFF26A69A),
      500: Color(_tealPrimaryValue),
      600: Color(0xFF00897B),
      700: Color(0xFF00796B),
      800: Color(0xFF00695C),
      900: Color(0xFF004D40),
    },
  );

  static const int _tealPrimaryValue = 0xFF009688;

  // static const MaterialColor teal = MaterialColor(_indigoPrimaryValue, <int, Color>{
  //   50: Color(0xFFE0F2F1),
  //   100: Color(0xFFB2DFDB),
  //   200: Color(0xFF80CBC4),
  //   300: Color(0xFF4DB6AC),
  //   400: Color(0xFF26A69A),
  //   500: Color(_indigoPrimaryValue),
  //   600: Color(0xFF00897B),
  //   700: Color(0xFF00796B),
  //   800: Color(0xFF00695C),
  //   900: Color(0xFF004D40),
  // });

  // Other colors

  static const Color colorTeal = Colors.teal;
  static const Color colorDarkGray = Color(0xFF6B6D7A);
  static const Color colorDarkBlue = Color(0xFF004D40);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBlack = Color(0xFF000000);
  static const Color colorGreen = Colors.green;
  static const Color colorRed = Colors.red;
  static const Color colorUnderline = Color(_tealPrimaryValue);
  static const Color colorCBCBCB = Color(0xFFCBCBCB);
}

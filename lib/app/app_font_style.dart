import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_font_weight.dart';

/// All app fonts are defined here
class AppFonts {
  AppFonts._();

  // static String sfProText = 'SF Pro Text';
  static String dMSans = 'DM Sans';

  // static TextStyle sfProTextStyle({double height = 1}) {
  //   return TextStyle(fontSize: 16, fontFamily: dMSans, height: height, fontWeight: AppFontWeight.regular, color: AppColors.colorBlack);
  // }

  static TextStyle dMSansTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontFamily: dMSans,
      fontWeight: AppFontWeight.regular,
      color: AppColors.colorBlack,
      decoration: TextDecoration.none,
    );
  }
}

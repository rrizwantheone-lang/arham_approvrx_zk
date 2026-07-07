import 'package:arham_b2c/app/app_colors.dart';
import 'package:flutter/services.dart';

class AppStatusBar {
  /// Sets the status bar color and brightness.
  static void setStatusBarStyle({
    Color statusBarColor = AppColors.teal,
    Brightness statusBarIconBrightness = Brightness.dark,
    Brightness statusBarBrightness = Brightness.light, // For iOS
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
    );
  }
}

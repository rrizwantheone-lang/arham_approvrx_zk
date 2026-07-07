import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppSnackBar {
  static void snackBarSuccessMsg(BuildContext context, String text) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: TextStyle(
          fontWeight: AppFontWeight.w400,
          fontSize: 16,
          color: AppColors.colorWhite,
        ),
      ),
      elevation: 6.0,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.colorGreen,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: AppColors.colorWhite,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void snackBarErrorMsg(BuildContext context, String text) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: TextStyle(
          fontWeight: AppFontWeight.w400,
          fontSize: 16,
          color: AppColors.colorWhite,
        ),
      ),
      elevation: 6.0,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.colorRed,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: AppColors.colorWhite,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showGetXCustomSnackBar1({
    required String message,
    Color backgroundColor = AppColors.colorRed,
  }) {
    Get.closeAllSnackbars();

    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: backgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16.0),
        duration: const Duration(seconds: 2),
        borderRadius: 5,
      ),
    );
  }

  static Future<void> showGetXCustomSnackBar({
    required String message,
    Color backgroundColor = Colors.red,
  }) async {
    final context = Get.overlayContext;

    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16, // 👈 keep it lower
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 6,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
    } else {
      Get.closeAllSnackbars();

      Get.rawSnackbar(
        message: message,
        backgroundColor: backgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    }
  }
}

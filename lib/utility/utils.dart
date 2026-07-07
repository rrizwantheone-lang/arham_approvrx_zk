import 'dart:convert';
import 'dart:io';

import 'package:arham_b2c/api/app_exception.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/models/login_firm_response.dart';
import 'package:arham_b2c/screens/home/home_controller.dart';
import 'package:arham_b2c/screens/login/login_view.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../app/app_colors.dart';
import '../app/app_font_weight.dart';

/// All app level utility methods are defined here
class Utils {
  Utils._();

  static String maskMobileNumber(String mobile) {
    if (mobile.length < 6) return mobile; // safety check

    final firstTwo = mobile.substring(0, 2);
    final lastFour = mobile.substring(mobile.length - 4);

    return '$firstTwo****$lastFour';
  }

  static String commonUTCDateFormat = 'yyyy-MM-ddThh:mm:ss';
  static String commonAppDateFormat = 'yyyy, MMM dd hh:mm a';

  static String filterPattern = r'^[0-9]*\.?[0-9]*$';
  static String filterPatternWithDecimal = r'^\d{0,12}(\.\d{0,2})?';

  static double convertToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int convertToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static double getScreenHeight({required BuildContext context}) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void handleException(Object e, [StackTrace? stackTrace]) {
    // Log error to Firebase Crashlytics
    FirebaseCrashlytics.instance.recordError(
      e,
      stackTrace ?? StackTrace.current,
      fatal: false,
    );

    String message;

    if (e is AppException && e.message != null) {
      message = e.message!;
    } else {
      message = Constants.somethingWrongMsg; // fallback
    }

    if (e is UnAuthorizedException) {
      PreferenceUtils.setIsLogin(false).then((_) {
        PreferenceUtils.setAuthToken('');
        PreferenceUtils.setLoginUserCode('');
        PreferenceUtils.setLoginUserName('');
        PreferenceUtils.setLoginCustID('');
        PreferenceUtils.setLoginUserRole('');
        PreferenceUtils.setLoginUserPassword('');
        PreferenceUtils.setLoginMobileNO('');
        PreferenceUtils.setSyncID('');
        PreferenceUtils.setUserCD('');
        PreferenceUtils.clearAllPreferences();
        //Get.deleteAll();
        Get.delete<HomeController>();
        Get.offAll(() => LoginView());

        AppSnackBar.showGetXCustomSnackBar(
          message: 'Logout successfully',
          backgroundColor: Colors.green,
        );
      });
    }

    AppSnackBar.showGetXCustomSnackBar(message: message);
  }

  static Future<void> successWithBack(String msg) async {
    Get.back();
    Utils.closeKeyboard(Get.context!);
    AppSnackBar.showGetXCustomSnackBar(
      message: msg,
      backgroundColor: AppColors.colorGreen,
    );
  }

  static Future<void> successWithoutBack(String msg) async {
    Utils.closeKeyboard(Get.context!);
    AppSnackBar.showGetXCustomSnackBar(
      message: msg,
      backgroundColor: AppColors.colorGreen,
    );
  }

  static Future<void> errorWithoutBack(String msg) async {
    Utils.closeKeyboard(Get.context!);
    AppSnackBar.showGetXCustomSnackBar(message: msg);
  }

  static void messageBottom(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CommonText(
                      padding: const EdgeInsets.only(top: 20),
                      text: 'Success',
                      fontSize: 19,
                      maxLine: 2,
                      color: AppColors.colorBlack,
                      fontWeight: AppFontWeight.regular,
                    ),
                  ],
                ).marginOnly(top: 50, left: 15, right: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 8,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith(
                              (states) => AppColors.teal,
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: CommonText(
                            text: 'OK',
                            color: AppColors.colorWhite,
                            fontSize: 16,
                            fontWeight: AppFontWeight.w600,
                          ),
                        ),
                      ).paddingOnly(left: 30, right: 30),
                    ],
                  ).marginOnly(top: 35, left: 15, right: 15),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget iconButton() {
    return SizedBox(
      height: 40,
      width: 40,
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          side: BorderSide(width: 1, color: AppColors.teal),
        ),
        child: InkWell(
          onTap: () {},
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashColor: AppColors.teal.withValues(alpha: 0.5),
          child: const RotatedBox(
            quarterTurns: 0,
            child: Icon(Icons.person, size: 16, color: AppColors.teal),
          ),
        ),
      ),
    );
  }

  static Future<XFile?> pickImage({
    required ImageSource source,
    required CameraDevice cameraDevice,
  }) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: cameraDevice,
      );
      if (pickedFile != null) {
        // selectedImage.value = File(pickedFile.path);
        debugPrint("SELECTED ::: ${pickedFile.path}");
        return pickedFile;
      } else {
        debugPrint('No image selected.');
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }

  static Widget commonCircularProgress() {
    return const CircularProgressIndicator(strokeWidth: 2);
  }

  static Future<String> convertFileToBase64(String filePath) async {
    var file = File(filePath);
    List<int> bytes = await file.readAsBytes();

    String base64String = base64.encode(bytes);
    return base64String;
  }

  static Widget noDataUI(String message) {
    return Center(
      child: SingleChildScrollView(
        // Wrap to allow scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const CommonAppImageSvg(
            //   imagePath: AppImages.svgNoData,
            //   height: 100,
            //   width: double.infinity,
            // ),
            // const SizedBox(height: 20),
            CommonText(
              text: message,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  static String numberFormat(val) {
    return NumberFormat('#,##0.00').format(val);
  }

  static Widget buildShimmerList() {
    final theme = Theme.of(Get.context!);
    final colorScheme = theme.colorScheme;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // Disable scroll while loading
      itemCount: 6,
      itemBuilder:
          (_, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Shimmer.fromColors(
              baseColor: colorScheme.primary.withValues(alpha: 0.2),
              highlightColor: colorScheme.onPrimary.withValues(alpha: 0.2),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
    );
  }

  static String formatIndianAmount(double? amount) {
    if (amount == null) return '';
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 2,
    );
    return formatter.format(amount).trim();
  }

  static String formatRate(String? rate) {
    if (rate == null || rate.isEmpty) return '';
    final parsed = double.tryParse(rate);
    return parsed != null ? parsed.toStringAsFixed(2) : rate;
  }

  static Map<String, DateTime> getFinancialYearRange() {
    DateTime now = DateTime.now();
    if (now.month >= 4) {
      return {
        'start': DateTime(now.year, 4, 1),
        'end': DateTime(now.year + 1, 3, 31),
      };
    } else {
      return {
        'start': DateTime(now.year - 1, 4, 1),
        'end': DateTime(now.year, 3, 31),
      };
    }
  }

  static DateTime? parseDate(String dateStr, String format) {
    try {
      final DateFormat formatter = DateFormat(format);
      return formatter.parse(dateStr);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }

  static void storeSelectedFirmObject(LoginFirmModel firm) {
    String firmJson =
    jsonEncode(firm.toJson()); // assuming your Firm model has toJson()
    PreferenceUtils.setFirmObject(firmJson);
  }

  static LoginFirmModel? getStoredFirmObject() {
    String? firmJson = PreferenceUtils.getFirmObject();
    if (firmJson.isNotEmpty) {
      Map<String, dynamic> firmMap = jsonDecode(firmJson);
      return LoginFirmModel.fromJson(firmMap);
    }
    return null;
  }
}
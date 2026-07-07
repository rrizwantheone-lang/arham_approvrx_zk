import 'package:arham_b2c/screens/home/home_controller.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/dio_client.dart';
import '../../app/app_snack_bar.dart';
import '../../app/app_url.dart';
import '../../utility/constants.dart';
import '../../utility/network.dart';
import '../../utility/preference_utils.dart';
import '../../utility/utils.dart';

class ChangeController extends GetxController{

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isDisable = false.obs;

  final currentFocus = FocusNode();
  final newFocus = FocusNode();
  final confirmFocus = FocusNode();

  var isCurrentObscured = true.obs;
  var isNewObscured = true.obs;
  var isConfirmObscured = true.obs;

  void toggleCurrent() => isCurrentObscured.value = !isCurrentObscured.value;
  void toggleNew() => isNewObscured.value = !isNewObscured.value;
  void toggleConfirm() => isConfirmObscured.value = !isConfirmObscured.value;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    currentFocus.dispose();
    newFocus.dispose();
    confirmFocus.dispose();
    super.onClose();
  }

  void validateAndChangePassword() {

    String current = currentPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    if (current.isEmpty && newPass.isEmpty && confirm.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: "All fields are required.",
      );
      return;
    }

    if (current.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: "Please enter your current password.",
      );
      return;
    }

    if (newPass.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: "Please enter your new password.",
      );
      return;
    }

    if (confirm.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: "Please confirm your new password.",
      );
      return;
    }

    if (current == newPass) {
      AppSnackBar.showGetXCustomSnackBar(
        message: "New password must be different from current password.",
      );
      return;
    }

    if (newPass != confirm) {
      AppSnackBar.showGetXCustomSnackBar(
        message: "New password and confirm password must be same.",
      );
      return;
    }

    _performChangePassword(current, newPass);
  }

  Future<void> _performChangePassword(String currentPassword, String newPassword) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {

        Map<String, dynamic> param = {
          "oldPassword": currentPassword,
          "newPassword": newPassword,
        };

        var response = await DioClient().post(
          AppURL.changePasswordURL,   // 👈 Add this in AppURL
          param,
        );

        if (response.statusCode == 200) {

          if (response.data['status'] == true) {

            Utils.closeKeyboard(Get.context!);

            // Get.find<BottomNavController>().changeIndex(0);
            // Get.offAll(() => HomeView());

            AppSnackBar.showGetXCustomSnackBar(
              message: "Password changed successfully",
              backgroundColor: Colors.green,
            );

            // currentPasswordController.clear();
            // newPasswordController.clear();
            // confirmPasswordController.clear();
            //
            // Get.back(); // go back after success

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
              Get.delete<BottomNavController>();
              Get.offAll(() => LoginView());
            });

          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'] ?? "Failed to change password",
            );
          }

        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: "Error: ${response.statusCode}",
          );
        }

      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }

    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isDisable(false);
    }
  }

}
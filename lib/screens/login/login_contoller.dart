import 'dart:async';

import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/login_firm_response.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/screens/signup/signup_view.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/app_exception.dart';

class LoginController extends GetxController {
  final TextEditingController clientCdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileNoWithOTPController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isDisable = false.obs;
  var isObscured = true.obs;
  var isTextFieldDisable = true.obs;
  var tempToken = ''.obs;

  var isDropdownLoading = false.obs;
  Rx<LoginFirmResponse> firmDropdownList = LoginFirmResponse().obs;
  final Rx<LoginFirmModel?> selectedDropdownFirm = Rx<LoginFirmModel?>(null);
  RxString selectedDropdownFirmName = ''.obs;
  RxString selectedDropdownSyncID = ''.obs;
  RxString errorMsg = ''.obs;

  final TextEditingController firmController = TextEditingController();
  FocusNode firmFocus = FocusNode();

  var isVerifyCheckLoading = false.obs;
  var isVerifyCheckDisable = false.obs;
  var isVerifyOTPLoading = false.obs;
  var isVerifyOTPDisable = false.obs;
  var isResendOTPLoading = false.obs;
  var isResendOTPDisable = false.obs;
  RxString mobileNo = ''.obs;
  RxBool isVerified = true.obs;
  Rx<TextEditingController> verifyOTPController = TextEditingController().obs;

  var isForgotPassLoading = false.obs;
  var isForgotPassDisable = false.obs;
  final TextEditingController forgotPasswordController =
      TextEditingController();
  FocusNode forgotPasswordFocus = FocusNode();

  RxBool isLoginWithOTP = false.obs;

  var isResetPasswordLoading = false.obs;
  var isResetPasswordDisable = false.obs;
  var isResetPasswordEnable = false.obs;
  var newPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;

  var newPasswordFocus = FocusNode();
  var confirmPassWordFocus = FocusNode();

  var isNewPasswordObscured = true.obs;
  var isConfirmPasswordObscured = true.obs;

  void newPassToggleObscured() {
    isNewPasswordObscured.value = !isNewPasswordObscured.value;
  }

  void confirmPassToggleObscured() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  var resendSeconds = 60.obs;
  var isResendEnabled = false.obs;
  Timer? _resendTimer;

  void startResendTimer() {
    resendSeconds.value = 60;
    isResendEnabled.value = false;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendSeconds.value == 0) {
        timer.cancel();
        isResendEnabled.value = true;
      } else {
        resendSeconds.value--;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    //Utils.hideStatusBar();

    PreferenceUtils.setAuthToken(''); // Save auth token
  }

  @override
  void onClose() {
    mobileNoWithOTPController.dispose();
    clientCdController.dispose();
    passwordController.dispose();
    firmController.dispose();
    forgotPasswordController.dispose();
    verifyOTPController.value.dispose();
    newPasswordController.value.dispose();
    confirmPasswordController.value.dispose();
    _resendTimer?.cancel();
    super.onClose();
  }

  void toggleObscured() {
    isObscured.value = !isObscured.value;
  }

  void tempLoginValidationWithUserCd() async {
    //if (formKey.currentState!.validate()) {
    if (clientCdController.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter user id.');
    } else if (passwordController.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter password.');
    } else {
      await _checkVerifiedWithCodeOTP(clientCdController.text);

      //await _performLoginWithUserCd(clientCdController.text, passwordController.text);
    }
    //}
  }

  void tempLoginValidationWithMobile() async {
    if (mobileNoWithOTPController.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter mobile number.',
      );
    } else if (mobileNoWithOTPController.text.isNotEmpty &&
        mobileNoWithOTPController.text.length != 10) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter a valid mobile number.',
      );
    } else {
      //await _checkVerifiedMobileOTP(mobileNoWithOTPController.text);
      await _performLoginWithMobile(mobileNoWithOTPController.text);
    }
  }

  Future<void> _checkVerifiedWithCodeOTP(String value) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'scUserCd': value};

        /// response is Map<String, dynamic>
        final response = await DioClient().getQueryParam(
          AppURL.isVerifiedOTPURL,
          queryParams: param,
        );

        /// Check API status flag
        if (response['status'] == true) {
          isTextFieldDisable.value = false;
          mobileNo.value = response['data']['SC_MOBILENO'];
          isVerified.value = response['data']['IS_VERIFIED'];
          Utils.closeKeyboard(Get.context!);

          if (isVerified.value == true) {
            _performLoginWithUserCd(
              clientCdController.value.text,
              passwordController.value.text,
            );
          } else {
            print('open otp fields');

            // AppSnackBar.showGetXCustomSnackBar(
            //   message: "OTP Not Verified",
            //   backgroundColor: Colors.red,
            // );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: response['message'] ?? "Verification failed",
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

  Future<void> _performLoginWithUserCd(String username, String password) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {
          //'clientCd': username,
          'scUserCd': username,
          'clientPwd': password,
        };

        var response = await DioClient().post(AppURL.loginURL, param);

        if (response.statusCode == 200) {
          if (response.data['message'] == 'Login Successful') {
            // isTextFieldDisable.value = true;
            // Utils.closeKeyboard(Get.context!);
            // tempToken.value = response.data['token'];
            //
            // verifiedOTP(username);

            //TODO : OLD COMMENT 15-01-2026
            isTextFieldDisable.value = true;

            Utils.closeKeyboard(Get.context!);
            tempToken.value = response.data['token'];

            if (tempToken.value.isNotEmpty) {
              PreferenceUtils.setAuthToken('Bearer ${tempToken.value}');
              PreferenceUtils.setIsLogin(true); // Store login state
              PreferenceUtils.setLoginUserCode(
                response.data['data']['SC_USER_CD'].toString(),
              );
              PreferenceUtils.setLoginCustID(
                response.data['data']['SC_CUST_ID'].toString(),
              );
              PreferenceUtils.setLoginUserName(
                response.data['data']['SC_USER_NAME'].toString(),
              );
              PreferenceUtils.setLoginMobileNO(
                response.data['data']['SC_MOBILENO'].toString(),
              );
              PreferenceUtils.setSyncID(
                response.data['data']['SC_SYNC_ID'].toString(),
              );

              if (tempToken.value.isNotEmpty) {
                _fetchFirmDropdown();
                //Call fetchFirmDropdown() after 3 seconds delay

                // Future.delayed(const Duration(seconds: 3), () {
                //   fetchFirmDropdown();
                // });
              }
            }
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
            isTextFieldDisable.value = true;
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
          isTextFieldDisable.value = true;
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('call $e');
      isTextFieldDisable.value = true;
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isDisable(false);
    }
  }

  Future<void> _fetchFirmDropdown() async {
    if (await Network.isConnected()) {
      try {
        isDropdownLoading(true);

        var response = await DioClient().getQueryParam(AppURL.getFirmURL);

        firmDropdownList.value = LoginFirmResponse.fromJson(response);

        if (firmDropdownList.value.data!.isNotEmpty) {
          isTextFieldDisable.value = false;

          var firstFirm = firmDropdownList.value.data!.first;
          selectedDropdownFirm.value = firstFirm;
          selectedDropdownFirmName.value = firstFirm.sCFIRMNAME.toString();
          selectedDropdownSyncID.value = firstFirm.sCSYNCID.toString();
          firmController.text = firstFirm.sCFIRMNAME ?? '';

          //PreferenceUtils.setUserCD(firstFirm.userCD);
          PreferenceUtils.setFirmID(firstFirm.sCFIRMID.toString());
          PreferenceUtils.setCustID(firstFirm.sCCUSTID.toString());
          PreferenceUtils.setSyncID(selectedDropdownSyncID.value);
          PreferenceUtils.setFirmName(firstFirm.sCFIRMNAME.toString());
          PreferenceUtils.setFirmGSTType(firstFirm.sCGSTTYPE.toString());
          PreferenceUtils.setFirmStateCD(firstFirm.sCSTATECODE.toString());
          PreferenceUtils.setFirmStateName(firstFirm.sCSTATE.toString());

          Utils.storeSelectedFirmObject(firstFirm);
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No Firms Available');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isDropdownLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void navigateToSignup() {
    Get.to(() => SignupView(), transition: Transition.rightToLeft);
    //Get.to(() => SignupViewNew());
  }

  void verifyOTPValidation() {
    if (verifyOTPController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter OTP.');
    } else if (verifyOTPController.value.text.isNotEmpty &&
        verifyOTPController.value.text.length < 6) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter a valid OTP.');
    } else {
      if (isLoginWithOTP.value) {
        mobileNoWithOTPController.text = mobileNo.value;

        _performLoginWithMobileOTP(
          mobileNo.value,
          verifyOTPController.value.text,
        );
      } else {
        _verifyOTP(mobileNo.value, verifyOTPController.value.text);
      }
    }
  }

  Future<void> _verifyOTP(String mobileNumber, String otp) async {
    try {
      isVerifyOTPLoading(true);
      isVerifyOTPDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber, 'otp': otp};

        var response = await DioClient().post(AppURL.verifyOTPURL, param);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // verifyOTPController.value.clear();
          // mobileNo.value = '';
          // isVerified.value = true;

          //isVerified.value = true;

          Utils.closeKeyboard(Get.context!);

          if (isResetPasswordEnable.value) {
            AppSnackBar.showGetXCustomSnackBar(
              message: 'Verify OTP successfully',
              backgroundColor: Colors.green,
            );

            //isResetPasswordEnable.value = true;
            isVerified.value = true;
            //isTextFieldDisable.value = false;
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: 'Verify OTP successfully',
              backgroundColor: Colors.green,
            );

            isVerified.value = true;
            //isTextFieldDisable.value = false;

            if (clientCdController.value.text.isNotEmpty &&
                passwordController.value.text.isNotEmpty) {
              //isVerified.value = true;
              isTextFieldDisable.value = false;

              _performLoginWithUserCd(
                clientCdController.value.text,
                passwordController.value.text,
              );
            }
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isVerifyOTPLoading(false);
      isVerifyOTPDisable(false);
    }
  }

  Future<void> resendOTP(String mobileNumber) async {
    try {
      isResendOTPLoading(true);
      isResendOTPDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber};

        var response = await DioClient().post(AppURL.resendOTPURL, param);

        if (response.statusCode == 200 || response.statusCode == 201) {
          verifyOTPController.value.clear();

          Utils.closeKeyboard(Get.context!);

          AppSnackBar.showGetXCustomSnackBar(
            message: 'OTP resent successfully',
            backgroundColor: Colors.green,
          );
          startResendTimer();

          //await Utils.successWithoutBack(response['message']);

          // if (response['status'] == true &&
          //     response['message'] == 'OTP resent successfully') {
          //   // mobileNo.value = response['data']['user']['SC_MOBILENO'];
          //   // isVerified.value = response['data']['verified'];
          //
          //   //isVerified.value = true;
          //
          //   verifyOTPController.value.clear();
          //
          //   Utils.closeKeyboard(Get.context!);
          //
          //   await Utils.successWithoutBack(response['message']);
          // } else {
          //   AppSnackBar.showGetXCustomSnackBar(
          //     message: response.data['message'],
          //   );
          // }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isResendOTPLoading(false);
      isResendOTPDisable(false);
    }
  }

  void changeFirmLoginWithAPI() {
    if (selectedDropdownFirmName.value.isEmpty &&
        selectedDropdownSyncID.value.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please select firm.');
    } else {
      _changeFirmLogin(selectedDropdownSyncID.value);
    }
  }

  Future<void> _changeFirmLogin(String dropdownId) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'scSyncId': dropdownId};

        var response = await DioClient().post(AppURL.changeFirmURL, param);
        print(response);

        if (response.statusCode == 200) {
          if (response.data['message'] == 'Login Successful') {
            Utils.closeKeyboard(Get.context!);

            String role = response.data['role'];
            String token = response.data['token'];

            PreferenceUtils.setLoginUserRole(role);
            PreferenceUtils.setAuthToken('Bearer $token');

            Get.offAll(() => HomeScreen());
            // Get.offAll(() => HomeView());

            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
              backgroundColor: Colors.green,
            );

            clientCdController.clear();
            passwordController.clear();

            verifyOTPController.value.clear();
            mobileNo.value = '';
            isVerified.value = true;

            firmDropdownList.value = LoginFirmResponse();
            selectedDropdownFirm.value = null;
            selectedDropdownFirmName.value = '';
            selectedDropdownSyncID.value = '';

            tempToken.value = '';

            isTextFieldDisable.value = true;

            mobileNoWithOTPController.clear();
            forgotPasswordController.clear();
            isLoginWithOTP.value = false;
          } else {
            // Show failure message based on the message from the response
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('call change firm $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isDisable(false);
    }
  }

  void forgotPasswordWithAPI() {
    if (forgotPasswordController.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter mobile number.',
      );
    } else if (forgotPasswordController.text.isNotEmpty &&
        forgotPasswordController.text.length != 10) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter a valid mobile number.',
      );
    } else {
      _forgotPassword(forgotPasswordController.text);
    }
  }

  Future<void> _forgotPassword(String mobileNumber) async {
    try {
      isForgotPassLoading(true);
      isForgotPassDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber};

        var response = await DioClient().post(AppURL.forgotPasswordURL, param);

        if (response.statusCode == 200 || response.statusCode == 201) {
          mobileNo.value = forgotPasswordController.text;
          forgotPasswordController.clear();

          Utils.closeKeyboard(Get.context!);

          AppSnackBar.showGetXCustomSnackBar(
            message: 'Forgot password send successfully',
            backgroundColor: Colors.green,
          );

          Get.back();

          startResendTimer();
          _checkVerifiedMobileOTP(mobileNo.value);
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isForgotPassLoading(false);
      isForgotPassDisable(false);
    }
  }

  Future<void> _checkVerifiedMobileOTP(String value) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': value};

        /// response is Map<String, dynamic>
        final response = await DioClient().getQueryParam(
          AppURL.isVerifiedOTPURL,
          queryParams: param,
        );

        /// Check API status flag
        if (response['status'] == true) {
          mobileNo.value = response['data']['SC_MOBILENO'];
          isVerified.value = response['data']['IS_VERIFIED'];
          isResetPasswordEnable.value = true;
          print('Mobile No Verified ${isVerified.value}');
          Utils.closeKeyboard(Get.context!);

          if (isVerified.value == true) {
            _performLoginWithUserCd(
              clientCdController.value.text,
              passwordController.value.text,
            );

            // if(isLoginWithOTP.value){
            //   _performLoginWithMobile(mobileNo.value);
            // }else {
            //   _performLoginWithUserCd(
            //     clientCdController.value.text,
            //     passwordController.value.text,
            //   );
            // }
          } else {
            print('open otp fields');

            // AppSnackBar.showGetXCustomSnackBar(
            //   message: "OTP Not Verified",
            //   backgroundColor: Colors.red,
            // );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: response['message'] ?? "Verification failed",
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

  Future<void> _performLoginWithMobile(String mobileNumber) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber};

        final response = await DioClient().post(
          AppURL.loginWithMobileURL,
          param,
        );

        final data = response.data; // ✅ IMPORTANT

        if (data != null && data['status'] == true) {
          mobileNo.value = mobileNumber;
          isVerified.value = false;
          Utils.closeKeyboard(Get.context!);

          AppSnackBar.showGetXCustomSnackBar(
            message:
                'OTP has been sent successfully to your mobile number $mobileNumber',
            backgroundColor: Colors.green,
          );
          startResendTimer();
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: data?['message'] ?? 'Verification failed',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } on UnAuthorizedException catch (e) {    //TODO: Added this for invalid mobile (24 Feb 2026)
      AppSnackBar.showGetXCustomSnackBar(
        message: "Invalid mobile number",
        backgroundColor: Colors.red,
      );
      return;
    } catch (e, stackTrace) {
      print('Login With Mobile $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isDisable(false);
    }
  }

  Future<void> _performLoginWithMobileOTP(
    String mobileNumber,
    String otp,
  ) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber, 'otp': otp};

        var response = await DioClient().post(
          AppURL.loginWithMobileVerifyOTPURL,
          param,
        );

        if (response.statusCode == 200) {
          if (response.data['message'] == 'Login Successful') {
            // isTextFieldDisable.value = true;
            // Utils.closeKeyboard(Get.context!);
            // tempToken.value = response.data['token'];
            //
            // verifiedOTP(username);

            //TODO : OLD COMMENT 15-01-2026
            isVerified.value = true;
            isTextFieldDisable.value = true;

            Utils.closeKeyboard(Get.context!);
            tempToken.value = response.data['token'];

            if (tempToken.value.isNotEmpty) {
              PreferenceUtils.setAuthToken('Bearer ${tempToken.value}');
              PreferenceUtils.setIsLogin(true); // Store login state
              PreferenceUtils.setLoginUserCode(
                response.data['data']['SC_USER_CD'].toString(),
              );
              PreferenceUtils.setLoginCustID(
                response.data['data']['SC_CUST_ID'].toString(),
              );
              PreferenceUtils.setLoginUserName(
                response.data['data']['SC_USER_NAME'].toString(),
              );
              PreferenceUtils.setLoginMobileNO(
                response.data['data']['SC_MOBILENO'].toString(),
              );
              PreferenceUtils.setSyncID(
                response.data['data']['SC_SYNC_ID'].toString(),
              );

              if (tempToken.value.isNotEmpty) {
                _fetchFirmDropdown();
                //Call fetchFirmDropdown() after 3 seconds delay

                // Future.delayed(const Duration(seconds: 3), () {
                //   fetchFirmDropdown();
                // });
              }
            }
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('call $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isDisable(false);
    }
  }

  void resetPasswordWithAPI() {
    if (newPasswordController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter new password.');
    } else if (confirmPasswordController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter confirm password.',
      );
    } else if (confirmPasswordController.value.text !=
        newPasswordController.value.text) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Confirm Password & New Password Not Match.',
      );
    } else {
      _resetPassword(
        mobileNo.value,
        verifyOTPController.value.text,
        newPasswordController.value.text,
      );
    }
  }

  Future<void> _resetPassword(
    String mobileNumber,
    String otp,
    String newPassword,
  ) async {
    try {
      isResetPasswordLoading(true);
      isResetPasswordDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {
          'mobileNo': mobileNumber,
          "otp": otp,
          "newPassword": newPassword,
        };

        var response = await DioClient().post(AppURL.resetPasswordURL, param);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Utils.closeKeyboard(Get.context!);

          AppSnackBar.showGetXCustomSnackBar(
            message: 'Reset password successfully',
            backgroundColor: Colors.green,
          );

          newPasswordController.value.clear();
          confirmPasswordController.value.clear();
          verifyOTPController.value.clear();
          forgotPasswordController.clear();

          mobileNo.value = '';
          isResetPasswordEnable.value = false;
          isVerified.value = true;
          isTextFieldDisable.value = true;
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isResetPasswordLoading(false);
      isResetPasswordDisable(false);
    }
  }
}

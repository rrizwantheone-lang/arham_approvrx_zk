import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/models/login_firm_response.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_image.dart';
import 'package:arham_b2c/widgets/common_input_dialog.dart';
import 'package:arham_b2c/widgets/common_text_button.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'login_contoller.dart' show LoginController;

class LoginView extends StatelessWidget {
  LoginView({super.key});

  //final LoginController controller = Get.put(LoginController());

  final LoginController controller = Get.put(
    LoginController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // child: Obx(
        //   () => Center(
        //     child: SingleChildScrollView(
        //       child: Padding(
        //         padding: const EdgeInsets.all(16.0),
        //         child:
        //             controller.isVerified.value
        //                 ? _loginView(context)
        //                 : _otpView(context),
        //       ),
        //     ),
        //   ),
        // ),
        child: Obx(() {
          final verified = controller.isVerified.value;
          final resetEnabled = controller.isResetPasswordEnable.value;

          return SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 75),
                child: _buildAuthView(context, verified, resetEnabled),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAuthView(
    BuildContext context,
    bool verified,
    bool resetEnabled,
  ) {
    if (verified && resetEnabled) {
      return _resetPasswordView(context);
    }

    if (verified) {
      return _loginView(context);
    }

    return _otpView(context);
  }

  Widget _loginView(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // isDark
          //     ? Center(
          //       child: CommonAppImageSvg(
          //         imagePath: AppImages.icDarkB2CSvg,
          //         height: 150,
          //         width: MediaQuery.sizeOf(context).width * 0.8,
          //       ),
          //     )
          //     : Center(
          //       child: CommonAppImageSvg(
          //         imagePath: AppImages.icLightB2CSvg,
          //         height: 150,
          //         width: MediaQuery.sizeOf(context).width * 0.8,
          //       ),
          //     ),
          Center(
            child: CommonAppImage(
              imagePath: 'assets/images/png/ic_app_logo.png',
              height: MediaQuery.sizeOf(context).height * 0.2,
              fit: BoxFit.contain,
              width: MediaQuery.sizeOf(context).width * 0.8,
            ),
          ),

          CommonText(
            text: 'Login',
            fontSize: AppDimensions.fontSizeExtraLarge,
            fontWeight: AppFontWeight.w600,
          ).paddingOnly(top: 16),

          Row(
            //spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Don't have an account?",
                fontSize: AppDimensions.fontSizeMedium,
                fontWeight: AppFontWeight.w400,
              ),

              CommonTextButton(
                title: 'Make Account',
                onPressed: () {
                  controller.navigateToSignup();
                },
              ),
              // InkWell(
              //   onTap: () {
              //     Get.toNamed(AppRoutes.signUpRoute);
              //   },
              //   child: CommonText(
              //     text: 'Make Account',
              //     fontSize: AppDimensions.fontSizeSmall,
              //     color: Theme.of(Get.context!).colorScheme.primary,
              //     fontWeight: AppFontWeight.w600,
              //   ),
              // ),
            ],
          ).paddingOnly(top: 4),

          if (!controller.isLoginWithOTP.value)
            CommonAppInput(
              textInputAction: TextInputAction.next,
              textEditingController: controller.clientCdController,
              hintText: 'User ID *',
              maxLength: 10,
              isEnable: controller.isTextFieldDisable.value,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your User ID';
                }
                return null;
              },
            ).paddingOnly(top: 8),
          if (!controller.isLoginWithOTP.value)
            Obx(
              () => CommonAppInput(
                textInputAction: TextInputAction.done,
                textEditingController: controller.passwordController,
                hintText: 'Password *',
                maxLength: 12,
                isEnable: controller.isTextFieldDisable.value,
                isPassword: controller.isObscured.value,
                // Use obscureText
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                suffixIcon:
                    controller.isObscured.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                onSuffixClick:
                    controller.toggleObscured, // Call function directly
              ).paddingOnly(top: 16),
            ),
          if (controller.isLoginWithOTP.value)
            CommonAppInput(
              textEditingController: controller.mobileNoWithOTPController,
              isEnable: controller.isTextFieldDisable.value,
              hintText: 'Mobile Number *',
              maxLength: 10,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // FilteringTextInputFormatter.allow(
                //     RegExp(r'^[6-9][0-9]{0,9}$')),
              ],
            ).paddingOnly(top: 8),
          controller.isDropdownLoading.isTrue
              ? Visibility(
                visible: controller.selectedDropdownSyncID.isNotEmpty,
                child: Center(
                  child: Utils.commonCircularProgress(),
                ).paddingOnly(top: 18, bottom: 18),
              )
              : Visibility(
                visible: controller.selectedDropdownSyncID.isNotEmpty,
                child: TypeAheadField<LoginFirmModel>(
                  controller: controller.firmController,
                  focusNode: controller.firmFocus,
                  suggestionsCallback: (pattern) async {
                    return controller.firmDropdownList.value.data?.where((
                      item,
                    ) {
                      return item.sCFIRMNAME
                          .toString()
                          .trim()
                          .toLowerCase()
                          .contains(pattern.toLowerCase());
                    }).toList();
                  },
                  itemBuilder: (context, LoginFirmModel suggestion) {
                    return ListTile(
                      visualDensity: const VisualDensity(
                        horizontal: -2.0,
                        vertical: -4.0,
                      ),
                      title: CommonText(
                        text:
                            suggestion.sCMOBILE1 != null &&
                                    suggestion.sCMOBILE1!.trim().isNotEmpty
                                ? "${suggestion.sCFIRMNAME.toString().trim()} | ${suggestion.sCMOBILE1!.toString().trim()}"
                                : suggestion.sCFIRMNAME.toString().trim(),
                        fontWeight: AppFontWeight.w400,
                        fontSize: 14,
                      ),
                    );
                  },
                  onSelected: (LoginFirmModel selectedItem) {
                    controller.selectedDropdownFirm.value = selectedItem;
                    controller.selectedDropdownSyncID.value =
                        selectedItem.sCSYNCID.toString();
                    controller.firmController.text =
                        selectedItem.sCFIRMNAME ?? '';

                    // Save firm details
                    PreferenceUtils.setFirmID(selectedItem.sCFIRMID.toString());
                    PreferenceUtils.setCustID(selectedItem.sCCUSTID.toString());
                    PreferenceUtils.setSyncID(
                      controller.selectedDropdownSyncID.value,
                    );
                    PreferenceUtils.setFirmName(
                      selectedItem.sCFIRMNAME.toString(),
                    );
                    PreferenceUtils.setFirmGSTType(
                      selectedItem.sCGSTTYPE.toString(),
                    );
                    PreferenceUtils.setFirmStateCD(
                      selectedItem.sCSTATECODE.toString(),
                    );
                    PreferenceUtils.setFirmStateName(
                      selectedItem.sCSTATE.toString(),
                    );
                  },
                  builder: (context, controllerValue, focusNode) {
                    return TextField(
                      controller: controllerValue,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        // suffixIconConstraints: const BoxConstraints(
                        //   minWidth: 16,
                        //   minHeight: 39,
                        // ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  controllerValue.clear();
                                  controller.firmController.clear();
                                  controller.selectedDropdownFirm.value = null;
                                  //controller.selectedDropdownSyncID.value = '';
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.close, size: 20),
                                ),
                              ),
                              const Icon(size: 20, Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                        labelText: 'Select Firm',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            // Default themed outline color
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            // Highlight color when focused
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                      ),
                    );
                  },
                ).paddingOnly(top: 16, bottom: 16),
              ),
          if (controller.tempToken.isEmpty)
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Obx(
                    () => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      // checkColor: AppColors.colorWhite,
                      // activeColor: AppColors.teal,
                      controlAffinity: ListTileControlAffinity.leading,
                      // Moves checkbox to right side
                      title: InkWell(
                        child: RichText(
                          text: TextSpan(
                            //text: 'Login With Mobile Number',
                            text: 'Login through OTP',
                            style: GoogleFonts.notoSans(
                              fontSize: AppDimensions.fontSizeRegular,
                              fontWeight: AppFontWeight.medium,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      value: controller.isLoginWithOTP.value,
                      onChanged: (value) {
                        controller.clientCdController.clear();
                        controller.passwordController.clear();
                        controller.mobileNoWithOTPController.clear();
                        controller.forgotPasswordController.clear();
                        //controller.isTextFieldDisable.value = true;
                        controller.isLoginWithOTP.value = value!;
                      },
                    ),
                  ).paddingOnly(top: 8, bottom: 8),
                ),
                if (controller.isLoginWithOTP.value == false &&
                    controller.tempToken.isEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CommonTextButton(
                      title: 'Forgot Password?',
                      underline: false,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (_) => CommonInputDialog(
                                title: 'Forgot Password',
                                message:
                                    'Enter your mobile number to forgot your password.',
                                controllerValue:
                                    controller.forgotPasswordController,
                                isLoading: controller.isForgotPassLoading,
                                onSubmit: () {
                                  controller.forgotPasswordWithAPI();
                                },
                                onCancel: () {
                                  controller.forgotPasswordController.clear();

                                  Get.back();
                                },
                              ),
                        );
                      },
                    ),
                  ).paddingOnly(top: 16, bottom: 16),
              ],
            ),

          // CommonButton(
          //   buttonText: 'Login',
          //   onPressed: controller.login,
          //   isLoading: controller.isLoading.value,
          //   isDisable: controller.isDisable.value,
          // ).paddingOnly(top: 16),
          CommonButton(
            buttonText:
                controller.selectedDropdownSyncID.value.isEmpty
                    ? 'Login'
                    : 'Continue',
            onPressed: () {
              if (controller.selectedDropdownSyncID.value.isEmpty) {
                if (controller.isLoginWithOTP.value) {
                  controller.tempLoginValidationWithMobile();
                } else {
                  controller.tempLoginValidationWithUserCd();
                }
              } else {
                controller.changeFirmLoginWithAPI();
              }
            },
            isLoading: controller.isLoading.value,
            isDisable: controller.isDisable.value,
          ),
        ],
      ),
    );
  }

  Widget _otpView(BuildContext context) {
    // controller.startResendTimer(); // restart timer

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outline;
    final surface = theme.colorScheme.surface;

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: TextStyle(
        fontSize: 20,
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: outline),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primary, width: 2),
      borderRadius: BorderRadius.circular(4),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: surface),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisSize: MainAxisSize.min,
      children: [
        CommonText(
          text: 'Verification',
          fontSize: AppDimensions.fontSizeExtraLarge,
          fontWeight: AppFontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
        ),
        CommonText(
          text: "Enter the code sent to the number",
          fontSize: AppDimensions.fontSizeMedium,
          fontWeight: AppFontWeight.w600,
        ).paddingOnly(top: 25),
        if (controller.mobileNo.value.isNotEmpty)
          Obx(
            () => CommonText(
              //text: controller.mobileNo.value,
              text: Utils.maskMobileNumber(controller.mobileNo.value),
              fontSize: AppDimensions.fontSizeMedium,
              fontWeight: AppFontWeight.w900,
            ).paddingOnly(top: 20),
          ),
        Pinput(
          length: 6,
          autofocus: true,
          showCursor: true,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          // 🚫 Disable all autofill
          autofillHints: const [],
          //androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
          keyboardType: TextInputType.number,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            debugPrint('OTP entered: $pin');
            controller.verifyOTPController.value.text = pin.toString();

            controller.verifyOTPValidation();
          },
          // validator: (s) {
          //   return controller.verifyOTPController.value.text = s.toString();
          // },
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        ).paddingOnly(top: 35),
        CommonText(
          text: "Didn't receive the code?",
          fontSize: AppDimensions.fontSizeMedium,
          fontWeight: AppFontWeight.w600,
        ).paddingOnly(top: 30),
        // controller.isResendOTPLoading.value
        //     ? SizedBox(
        //       height: 25,
        //       child: Center(child: Utils.commonCircularProgress()),
        //     )
        //     : CommonTextButton(
        //       title: 'Resend',
        //       underline: true,
        //       onPressed: () {
        //         controller.resendOTP(controller.mobileNo.value);
        //       },
        //     ).paddingOnly(top: 10),
        Obx(() {
          if (controller.isResendOTPLoading.value) {
            return const SizedBox(
              height: 25,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (!controller.isResendEnabled.value) {
            return CommonText(
              text: 'Resend in ${controller.resendSeconds.value}s',
              fontSize: 14,
            ).paddingOnly(top: 10);
          }

          return CommonTextButton(
            title: 'Resend',
            underline: true,
            onPressed: () {
              controller.resendOTP(controller.mobileNo.value);
              controller.startResendTimer(); // restart timer
            },
          ).paddingOnly(top: 10);
        }),
        Obx(
          () => CommonButton(
            buttonText: 'Verify OTP',
            onPressed: controller.verifyOTPValidation,
            isLoading: controller.isVerifyOTPLoading.value,
            isDisable: controller.isVerifyOTPDisable.value,
          ),
        ).paddingOnly(top: 16),
      ],
    );
  }

  Widget _resetPasswordView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisSize: MainAxisSize.min,
      children: [
        CommonText(
          text: 'Reset Password',
          fontSize: AppDimensions.fontSizeExtraLarge,
          fontWeight: AppFontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
        ),
        if (controller.mobileNo.value.isNotEmpty)
          Obx(
            () => CommonText(
              //text: controller.mobileNo.value,
              text:
                  "OTP verified for ${Utils.maskMobileNumber(controller.mobileNo.value)}.Enter your new password below.",
              fontSize: AppDimensions.fontSizeMedium,
              fontWeight: AppFontWeight.w900,
            ).paddingOnly(top: 25),
          ),
        SizedBox(height: 20),
        CommonAppInput(
          maxLines: 1,
          suffixIcon:
              controller.isNewPasswordObscured.value
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
          onSubmitted: (val) {
            FocusScope.of(
              context,
            ).requestFocus(controller.confirmPassWordFocus);
          },
          onSuffixClick: () => controller.newPassToggleObscured(),
          textInputAction: TextInputAction.next,
          textEditingController: controller.newPasswordController.value,
          hintText: "Password",
          maxLength: 12,
          focusNode: controller.newPasswordFocus,
          isPassword: controller.isNewPasswordObscured.value ? true : false,
          nextFocusNode: controller.confirmPassWordFocus,
        ),
        SizedBox(height: 20,),
        CommonAppInput(
          maxLines: 1,
          textInputAction: TextInputAction.done,
          suffixIcon:
              controller.isConfirmPasswordObscured.value
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
          maxLength: 12,
          onSuffixClick: () => controller.confirmPassToggleObscured(),
          textEditingController: controller.confirmPasswordController.value,
          hintText: "Confirm Password",
          focusNode: controller.confirmPassWordFocus,
          isPassword: controller.isConfirmPasswordObscured.value ? true : false,
        ),
        Obx(
          () => CommonButton(
            buttonText: 'Reset Password',
            onPressed: () {
              controller.resetPasswordWithAPI();
            },
            isLoading: controller.isResetPasswordLoading.value,
            isDisable: controller.isResetPasswordDisable.value,
          ),
        ).paddingOnly(top: 20),
      ],
    );
  }
}

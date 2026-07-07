import 'dart:io';

import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/models/state_response.dart';
import 'package:arham_b2c/screens/signup/pincode_response.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_date_picker.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:arham_b2c/widgets/common_text_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/common_dropdown.dart';
import '../../widgets/common_file_picker.dart';
import '../../widgets/terms_bottom_sheet_without_draggble.dart';
import 'signup_contoller.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final SignupController controller = Get.put(SignupController());

  // final SignupController controller = Get.put(
  //   SignupController(),
  //   permanent: true,
  // );

  final ImagePicker _picker = ImagePicker();

  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    //bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  controller.isVerified.value
                      ? _signUpView(context)
                      : _otpView(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // isDark
        //     ? Center(
        //       child: CommonAppImageSvg(
        //         imagePath: AppImages.icDarkB2CSvg,
        //         height: 150,
        //         width: MediaQuery.sizeOf(context).width,
        //       ),
        //     )
        //     : Center(
        //       child: CommonAppImageSvg(
        //         imagePath: AppImages.icLightB2CSvg,
        //         height: 150,
        //         width: MediaQuery.sizeOf(context).width,
        //       ),
        //     ),
        //SizedBox(height: 16),
        CommonText(
          text: 'Signup',
          fontSize: AppDimensions.fontSizeExtraLarge,
          fontWeight: AppFontWeight.w500,
        ),
        Row(
          //spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: "Already have an account?",
              fontSize: AppDimensions.fontSizeMedium,
              fontWeight: AppFontWeight.w400,
            ),
            CommonTextButton(
              title: 'Login',
              onPressed: () {
                Get.back();
              },
            ),
            // InkWell(
            //   onTap: () {
            //     Get.back();
            //   },
            //   child: CommonText(
            //     text: 'Login',
            //     fontSize: AppDimensions.fontSizeMedium,
            //     color: Theme.of(Get.context!).colorScheme.primary,
            //     fontWeight: AppFontWeight.w600,
            //   ),
            // ),
          ],
        ),

        const SizedBox(height: 16),
        buildStepper(context, controller),
        const SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (_, index) => buildStepForm(controller, index),
          ),
        ),
        Row(
          children: [
            if (controller.currentStep.value > 0)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: controller.previousStep,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: CommonText(text: "Back"),
                  ),
                ),
              ),

            if (controller.currentStep.value > 0) const SizedBox(width: 10),

            Expanded(
              child: CommonButton(
                buttonText:
                    controller.currentStep.value == 2 ? "Sign Up" : "Next",
                onPressed: () {
                  if (controller.currentStep.value == 2) {
                    controller.submit(context);
                  } else {
                    controller.nextStep(context);
                  }
                },
                isLoading:
                    controller.currentStep.value == 2
                        ? controller.isSignupLoading.value
                        : false,
              ),
            ),

            // Expanded(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if (controller.currentStep.value == 2) {
            //         controller.submit(context);
            //       } else {
            //         controller.nextStep(context);
            //       }
            //     },
            //     child: Text(controller.currentStep.value == 2
            //         ? "Submit"
            //         : "Next"),
            //   ),
            // ),
          ],
        ),

        // Obx(
        //   () => CommonButton(
        //     buttonText: 'Sign Up',
        //     onPressed: controller.signupValidation,
        //     isLoading: controller.isLoading.value,
        //     isDisable: controller.isDisable.value,
        //   ),
        // ),
      ],
    );
  }

  // ignore: unused_element
  Widget _otpView1(BuildContext context) {
    controller.startResendTimer(); // restart timer

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
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
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
              //         height: 25,
              //         child: Center(child: Utils.commonCircularProgress()),
              //       )
              //     : CommonTextButton(
              //         title: 'Resend',
              //         underline: true,
              //         onPressed: () {
              //           controller.resendOTP(controller.mobileNo.value);
              //         },
              //       ).paddingOnly(top: 10),
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
              // Obx(
              //   () => CommonButton(
              //     buttonText: 'Verify OTP',
              //     onPressed: controller.verifyOTPValidation,
              //     isLoading: controller.isVerifyOTPLoading.value,
              //     isDisable: controller.isVerifyOTPDisable.value,
              //   ),
              // ).paddingOnly(top: 16),
            ],
          ),
        ),
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
              text: controller.mobileNo.value,
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
        //         height: 25,
        //         child: Center(child: Utils.commonCircularProgress()),
        //       )
        //     : CommonTextButton(
        //         title: 'Resend',
        //         underline: true,
        //         onPressed: () {
        //           controller.resendOTP(controller.mobileNo.value);
        //         },
        //       ).paddingOnly(top: 10),
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

  void pickImage(int docNumber) {
    Get.bottomSheet(
      SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Get.back();
                  if (kIsWeb) {
                    // Web does not support camera
                    AppSnackBar.showGetXCustomSnackBar(
                      message: "Camera not supported on web.",
                    );
                    return;
                  }

                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    _setImageFile(docNumber, File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Get.back();
                  if (kIsWeb) {
                    // Use FilePicker for web
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );
                    if (result != null && result.files.single.bytes != null) {
                      _setWebImageFile(
                        docNumber,
                        result.files.single.bytes!,
                        result.files.single.name,
                      );
                    }
                  } else {
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      _setImageFile(docNumber, File(pickedFile.path));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setImageFile(int docNumber, File file) {
    if (docNumber == 1) {
      controller.doc1File.value = file;
      controller.doc1Web.value = null;
      controller.doc1WebName.value = null;
    } else {
      controller.doc2File.value = file;
      controller.doc2Web.value = null;
      controller.doc2WebName.value = null;
    }
  }

  void _setWebImageFile(int docNumber, Uint8List fileBytes, String fileName) {
    if (docNumber == 1) {
      controller.doc1Web.value = fileBytes;
      controller.doc1WebName.value = fileName;
      print(controller.doc1WebName.value);
      controller.doc1File.value = null;
    } else {
      controller.doc2Web.value = fileBytes;
      controller.doc2WebName.value = fileName;
      controller.doc2File.value = null;
    }
  }

  void pickImage1(int docNumber) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () async {
                Get.back(); // Close Bottom Sheet
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedFile != null) {
                  _setImageFile(docNumber, File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () async {
                Get.back(); // Close Bottom Sheet
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  _setImageFile(docNumber, File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  void _setImageFile1(int docNumber, File file) {
    if (docNumber == 1) {
      controller.doc1File.value = file;
    } else if (docNumber == 2) {
      controller.doc2File.value = file;
    }
  }

  void clearFile(int docNumber) {
    if (docNumber == 1) {
      controller.doc1File.value = null;
    } else if (docNumber == 2) {
      controller.doc2File.value = null;
    }
  }

  Widget buildStepper(BuildContext context, SignupController controller) {
    final theme = Theme.of(context);
    final steps = ['Basic Info', 'Licenses', 'User Info'];
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        bool isActive = index == controller.currentStep.value;
        bool isCompleted = index < controller.currentStep.value;

        final primaryColor = colorScheme.primary;
        final backgroundColor = theme.colorScheme.primaryContainer;
        //final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
        final inactiveBgColor = colorScheme.surfaceContainer;

        return Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    isCompleted
                        ? primaryColor
                        : isActive
                        ? backgroundColor
                        : inactiveBgColor,
                child:
                    isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            //color: isActive ? primaryColor : textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              const SizedBox(width: 6),
              Text(
                steps[index],
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  //color: isCompleted ? primaryColor : textColor,
                ),
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Divider(
                    color: colorScheme.outlineVariant,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          CommonDropdown(
            labelText: 'Business Type *',
            hintText: 'Select Business Type',
            value: controller.selectedBusinessType.value,
            items: ['Chemist', 'Doctor', 'Hospital', 'General Store'],
            onChanged:
                (value) => controller.selectedBusinessType.value = value!,
          ),
          SizedBox(height: 16),
          Obx(
            () => CommonAppInput(
              textEditingController: controller.firmNameController.value,
              //hintText: controller.selectedBusinessType.value + ' Name * ',
              hintText: 'Firm Name *',
              maxLength: 60,
              textInputAction: TextInputAction.next,
            ),
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.personNmController.value,
            hintText: 'Person Name *',
            maxLength: 60,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.addressController.value,
            hintText: 'Address *',
            maxLength: 255,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.pinCodeController.value,
            hintText: 'Pin Code',
            maxLength: 6,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (val) {
              // if (val.length >= 6) {
              //   controller.fetchCity(val);
              // }
              if (val.length == 6) {
                controller.fetchArea(val);
              }
            },
          ),
          SizedBox(height: 16),

          Obx(
            () =>
                controller.isAreaDropdownLoading.isTrue
                    ? Center(child: Utils.commonCircularProgress())
                    : TypeAheadField<PinCodeModel>(
                      controller: controller.zoneController.value,
                      suggestionsCallback: (pattern) async {
                        return controller.areaList.value.postOffice?.where((
                          item,
                        ) {
                          return item.name!.toLowerCase().contains(
                            pattern.toLowerCase(),
                          );
                        }).toList();
                      },
                      itemBuilder: (context, PinCodeModel suggestion) {
                        return ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: -2.0,
                            vertical: -4.0,
                          ),
                          title: CommonText(
                            text: suggestion.name!.trim(),
                            fontWeight: AppFontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      },
                      onSelected: (PinCodeModel selectedItem) {
                        controller.selectedDropdownArea.value = selectedItem;
                        controller.zoneController.value.text =
                            selectedItem.name!.trim();
                        Utils.closeKeyboard(Get.context!);

                        controller.fetchState();
                      },
                      builder: (context, textController, focusNode) {
                        final theme = Theme.of(context);
                        final colorScheme = theme.colorScheme;

                        return TextField(
                          maxLength: 50,
                          controller: textController,
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
                                      textController.clear();
                                      controller.selectedDropdownArea.value =
                                          null;
                                      controller.selectedDropdownAreaCD.value =
                                          '';
                                      controller
                                          .selectedDropdownAreaName
                                          .value = '';

                                      controller.selectedDropdownCity.value =
                                          null;
                                      controller
                                          .selectedDropdownCityName
                                          .value = '';
                                      controller.selectedDropdownCityCD.value =
                                          '';
                                      controller.cityController.value.clear();

                                      controller.selectedDropdownState.value =
                                          null;
                                      controller
                                          .selectedDropdownStateName
                                          .value = '';
                                      controller.selectedDropdownStateCD.value =
                                          '';
                                      controller.stateController.value.clear();
                                      controller.stateCdController.value
                                          .clear();

                                      Utils.closeKeyboard(Get.context!);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.close, size: 20),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, size: 20),
                                ],
                              ),
                            ),
                            labelText: 'Select Area',
                            //labelStyle: TextStyle(color: colorScheme.onSurface),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.outline,
                                // Default themed outline color
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                        );
                      },
                    ),
          ),

          // CommonAppInput(
          //   textEditingController: controller.zoneController.value,
          //   hintText: 'Area',
          //   maxLength: 50,
          //   textInputAction: TextInputAction.next,
          // ),
          SizedBox(height: 16),

          Obx(
            () =>
                controller.isCityDropdownLoading.isTrue
                    ? Center(child: Utils.commonCircularProgress())
                    : TypeAheadField<PinCodeModel>(
                      controller: controller.cityController.value,
                      suggestionsCallback: (pattern) async {
                        return controller.uniqueBlockList.where((item) {
                          return (item.block ?? '').toLowerCase().contains(
                            pattern.toLowerCase(),
                          );
                        }).toList();
                      },
                      itemBuilder: (context, PinCodeModel suggestion) {
                        return ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: -2.0,
                            vertical: -4.0,
                          ),
                          title: CommonText(
                            text: suggestion.block?.trim() ?? '',
                            fontWeight: AppFontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      },
                      onSelected: (PinCodeModel selectedItem) {
                        controller.selectedDropdownCity.value = selectedItem;
                        controller.cityController.value.text =
                            selectedItem.block?.trim() ?? '';
                        Utils.closeKeyboard(Get.context!);
                      },
                      builder: (context, textController, focusNode) {
                        final theme = Theme.of(context);
                        final colorScheme = theme.colorScheme;

                        return TextField(
                          maxLength: 50,
                          enabled: true,
                          controller: textController,
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
                                      textController.clear();
                                      controller.selectedDropdownCity.value =
                                          null;
                                      controller.selectedDropdownCityCD.value =
                                          '';
                                      controller
                                          .selectedDropdownCityName
                                          .value = '';
                                      Utils.closeKeyboard(Get.context!);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.close, size: 20),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, size: 20),
                                ],
                              ),
                            ),
                            labelText: 'Select City',
                            isDense: true,
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.outline,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.outline,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                        );
                      },
                    ),
          ),

          // controller.isCityDropdownLoading.isTrue
          //     ? Center(child: Utils.commonCircularProgress())
          //     : TypeAheadField<PinCodeModel>(
          //       controller: controller.cityController.value,
          //       suggestionsCallback: (pattern) async {
          //         return controller.cityList.value.postOffice?.where((item) {
          //           return item.name!.toLowerCase().contains(
          //             pattern.toLowerCase(),
          //           );
          //         }).toList();
          //       },
          //       itemBuilder: (context, PinCodeModel suggestion) {
          //         return ListTile(
          //           visualDensity: const VisualDensity(
          //             horizontal: -2.0,
          //             vertical: -4.0,
          //           ),
          //           title: CommonText(
          //             text: suggestion.name!.trim(),
          //             fontWeight: AppFontWeight.w400,
          //             fontSize: 16,
          //             color: Theme.of(context).colorScheme.onSurface,
          //           ),
          //         );
          //       },
          //       onSelected: (PinCodeModel selectedItem) {
          //         controller.selectedDropdownCity.value = selectedItem;
          //         controller.cityController.value.text =
          //             selectedItem.name!.trim();
          //         Utils.closeKeyboard(Get.context!);
          //       },
          //       builder: (context, textController, focusNode) {
          //         final theme = Theme.of(context);
          //         final colorScheme = theme.colorScheme;
          //
          //         return TextField(
          //           maxLength: 50,
          //           enabled: true,
          //           controller: textController,
          //           focusNode: focusNode,
          //           textInputAction: TextInputAction.next,
          //           decoration: InputDecoration(
          //             counter: const Offstage(),
          //             suffixIconConstraints: const BoxConstraints(
          //               minWidth: 16,
          //               minHeight: 39,
          //             ),
          //             suffixIcon: Padding(
          //               padding: const EdgeInsets.only(right: 10),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   InkWell(
          //                     onTap: () {
          //                       textController.clear();
          //                       controller.selectedDropdownCity.value = null;
          //                       controller.selectedDropdownCityCD.value = '';
          //                       controller.selectedDropdownCityName.value = '';
          //                       Utils.closeKeyboard(Get.context!);
          //                     },
          //                     child: const Padding(
          //                       padding: EdgeInsets.all(8.0),
          //                       child: Icon(Icons.close, size: 24),
          //                     ),
          //                   ),
          //                   Icon(
          //                     Icons.keyboard_arrow_down,
          //                     size: 24,
          //                     //color: colorScheme.onSurface,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             labelText: 'Select City',
          //             //labelStyle: TextStyle(color: colorScheme.onSurface),
          //             isDense: true,
          //             disabledBorder: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                 color: colorScheme.outline,
          //                 // Default themed outline color
          //                 width: 1,
          //               ),
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                 color: colorScheme.outline,
          //                 // Default themed outline color
          //                 width: 1,
          //               ),
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                 color: colorScheme.primary,
          //                 // Highlight color when focused
          //                 width: 1,
          //               ),
          //               borderRadius: BorderRadius.circular(10.0),
          //             ),
          //             contentPadding: const EdgeInsets.symmetric(
          //               vertical: 14.0,
          //               horizontal: 18.0,
          //             ),
          //           ),
          //           style: TextStyle(color: colorScheme.onSurface),
          //         );
          //       },
          //     ),

          // CommonAppInput(
          //   textEditingController: controller.cityController.value,
          //   hintText: 'City',
          //   maxLength: 50,
          //   textInputAction: TextInputAction.next,
          // ),
          SizedBox(height: 16),
          controller.isStateDropdownLoading.isTrue
              ? Center(child: Utils.commonCircularProgress())
              : TypeAheadField<StateModel>(
                controller: controller.stateController.value,
                focusNode: controller.stateFocus,
                suggestionsCallback: (pattern) async {
                  return controller.stateList.value.data?.where((item) {
                    return item.stateName!.toLowerCase().contains(
                      pattern.toLowerCase(),
                    );
                  }).toList();
                },
                itemBuilder: (context, StateModel suggestion) {
                  return ListTile(
                    visualDensity: const VisualDensity(
                      horizontal: -2.0,
                      vertical: -4.0,
                    ),
                    title: CommonText(
                      text: suggestion.stateName!.trim(),
                      fontWeight: AppFontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
                onSelected: (StateModel selectedItem) {
                  controller.selectedDropdownState.value = selectedItem;
                  controller.selectedDropdownStateCD.value =
                      selectedItem.stateCd!.trim();
                  controller.stateController.value.text =
                      selectedItem.stateName!.trim();
                  controller.stateCdController.value.text =
                      selectedItem.stateCd!.trim();
                  Utils.closeKeyboard(Get.context!);
                },
                builder: (context, textController, focusNode) {
                  final theme = Theme.of(context);
                  final colorScheme = theme.colorScheme;

                  return TextField(
                    maxLength: 50,
                    enabled: false,
                    controller: textController,
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
                                textController.clear();
                                controller.stateFocus.unfocus();
                                controller.selectedDropdownState.value = null;
                                controller.selectedDropdownStateCD.value = '';
                                controller.selectedDropdownStateName.value = '';
                                controller.stateCdController.value.clear();
                                controller.stateCDFocus.unfocus();
                                Utils.closeKeyboard(Get.context!);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.close, size: 20),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              //color: colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                      labelText: 'Select State',
                      //labelStyle: TextStyle(color: colorScheme.onSurface),
                      isDense: true,
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.outline,
                          // Default themed outline color
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.outline,
                          // Default themed outline color
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          // Highlight color when focused
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    style: TextStyle(color: colorScheme.onSurface),
                  );
                },
              ),
          SizedBox(height: 16),

          // CustomDropdown(
          //   labelText: 'State',
          //   hintText: 'Select State',
          //   value: controller.selectedState.value,
          //   items: ['State1', 'State2', 'State3'],
          //   onChanged:
          //       (value) => controller.selectedState.value = value!,
          // ),
          // SizedBox(height: 16),
          // CustomDropdown(
          //   labelText: 'City',
          //   hintText: 'Select City',
          //   value: controller.selectedCity.value,
          //   items: ['City1', 'City2', 'City3'],
          //   onChanged:
          //       (value) => controller.selectedCity.value = value!,
          // ),
          // SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Obx(
            () => CommonAppInput(
              textEditingController: controller.clientCdController.value,
              hintText: 'User ID *',
              textInputAction: TextInputAction.next,
              maxLength: 10,
              onChanged: controller.onClientCdChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              validator:
                  (value) => value!.isEmpty ? 'Please enter the user id' : null,
              suffixWidget:
                  controller.isUserExitsLoading.value
                      ? SizedBox(
                        width: 18,
                        height: 18,
                        child: Center(child: Utils.commonCircularProgress()),
                      )
                      : null,
            ),
          ),
          Obx(() {
            return controller.errorMsg.value.isNotEmpty
                ? CommonText(text: controller.errorMsg.value, color: Colors.red)
                : const SizedBox.shrink();
          }),
          SizedBox(height: 16),
          Obx(
            () => CommonAppInput(
              textInputAction: TextInputAction.next,
              textEditingController: controller.clientPwdController.value,
              hintText: 'Password *',
              maxLength: 12,
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
            ),
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.mobile1Controller.value,
            hintText: 'Mobile 1 *',
            maxLength: 10,
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              // FilteringTextInputFormatter.allow(
              //     RegExp(r'^[6-9][0-9]{0,9}$')),
            ],
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.mobile2Controller.value,
            hintText: 'Mobile 2',
            textInputAction: TextInputAction.next,
            maxLength: 10,
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              // FilteringTextInputFormatter.allow(
              //     RegExp(r'^[6-9][0-9]{0,9}$')),
            ],
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.emailIdController.value,
            hintText: 'Email ID *',
            maxLength: 255,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.upiController.value,
            hintText: 'UPI',
            textInputAction: TextInputAction.next,
            maxLength: 80,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.referralCodeController.value,
            hintText: 'Referral Code (Optional)',
            textInputAction: TextInputAction.done,
            maxLength: 50,
            textCapitalization: TextCapitalization.characters,
          ),
          SizedBox(height: 16),

          Obx(
            () => CheckboxListTile(
              // checkColor: AppColors.colorWhite,
              // activeColor: AppColors.teal,
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: const VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              dense: true,
              title: InkWell(
                child: RichText(
                  text: TextSpan(
                    text:
                        'By clicking Register, you have read and agreed to the ',
                    style: GoogleFonts.notoSans(
                      fontSize: AppDimensions.fontSizeSmall,
                      fontWeight: AppFontWeight.regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //   color: Theme.of(context).colorScheme.onSurface, // theme-aware color
                    // ),
                    children: [
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Get.bottomSheet(
                                //   BottomSheetWithWebView(
                                //     url:
                                //         'https://www.arhamerp.com/terms',
                                //   ),
                                //   isScrollControlled: true,
                                //   isDismissible: false,
                                // );

                                if (kIsWeb) {
                                  html.window.open(
                                    'https://arhamcorp.in/terms',
                                    '_blank',
                                  );
                                } else if (isMobile) {
                                  Get.dialog(
                                    barrierDismissible: false,
                                    useSafeArea: true,
                                    Dialog(
                                      insetPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.8,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child:
                                              BottomSheetWithWebViewWithoutDraggable(
                                                url:
                                                    'https://arhamcorp.in/terms',
                                              ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  launchUrl(
                                    Uri.parse('https://arhamcorp.in/terms'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.notoSans(
                          fontSize: AppDimensions.fontSizeSmall,
                          fontWeight: AppFontWeight.regular,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        //   color: Theme.of(context).colorScheme.onSurface, // theme-aware color
                        // ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Get.bottomSheet(
                                //   BottomSheetWithWebView(
                                //     url:
                                //         'https://www.arhamerp.com/privacy-policy',
                                //   ),
                                //   isScrollControlled: true,
                                //   isDismissible: false,
                                // );

                                // Get.bottomSheet(
                                //   BottomSheetWithWebViewWithoutDraggable(
                                //     url:
                                //     'https://www.arhamerp.com/privacy-policy',
                                //   ),
                                //   isScrollControlled: true,
                                //   isDismissible: false,
                                // );

                                // Get.dialog(
                                //   Dialog(
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                //     child: SizedBox(
                                //       width: MediaQuery.of(context).size.width * 0.9,
                                //       height: MediaQuery.of(context).size.height * 0.8,
                                //       child: ClipRRect(
                                //         borderRadius: BorderRadius.circular(15),
                                //         child: BottomSheetWithWebView(url: 'https://www.arhamerp.com/privacy-policy'),
                                //       ),
                                //     ),
                                //   ),
                                // );

                                if (kIsWeb) {
                                  html.window.open(
                                    'https://arhamcorp.in/privacy-policy',
                                    '_blank',
                                  );
                                } else {
                                  Get.dialog(
                                    barrierDismissible: false,
                                    useSafeArea: true,
                                    Dialog(
                                      insetPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.8,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child: BottomSheetWithWebViewWithoutDraggable(
                                            url:
                                                'https://arhamcorp.in/privacy-policy',
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                      TextSpan(
                        text: ' of B2C ',
                        style: GoogleFonts.notoSans(
                          fontSize: AppDimensions.fontSizeSmall,
                          fontWeight: AppFontWeight.regular,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        //   color: Theme.of(context).colorScheme.onSurface, // theme-aware color
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              value: controller.termsAccepted.value,
              onChanged: (value) => controller.termsAccepted.value = value!,
            ),
          ),

          Obx(
            () => CheckboxListTile(
              // checkColor: AppColors.colorWhite,
              // activeColor: AppColors.teal,
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: const VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              dense: true,
              title: CommonText(
                text:
                    'Yes, I would like to receive Transactional & Promotional materials',
                fontSize: AppDimensions.fontSizeSmall,
                fontWeight: AppFontWeight.regular,
              ),
              value: controller.promotionalAgreed.value,
              onChanged: (value) => controller.promotionalAgreed.value = value!,
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Visibility(
            visible:
                controller.selectedBusinessType.value == 'Doctor' ||
                controller.selectedBusinessType.value == 'Hospital' ||
                controller.selectedBusinessType.value == 'General Store',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonText(text: 'Add Registration Number', fontSize: 18),
                SizedBox(height: 16),
                CommonAppInput(
                  textEditingController:
                      controller.registrationNo1Controller.value,
                  hintText: 'Registration No 1',
                  maxLength: 80,
                  textInputAction: TextInputAction.next,
                ),
                Obx(
                  () => Visibility(
                    visible: controller.reg2Visible.value,
                    child: SizedBox(height: 16),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.reg2Visible.value,
                    child: CommonAppInput(
                      textEditingController:
                          controller.registrationNo2Controller.value,
                      hintText: 'Registration No 2',
                      maxLength: 80,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: '+Add More Registration Number ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            controller.reg2Visible.value =
                                !controller.reg2Visible.value;

                            print(controller.reg2Visible.value);
                          },
                    children: [
                      TextSpan(
                        text: '(Max 2 RN)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.selectedBusinessType.value == 'Chemist',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonText(text: 'Upload Drug License Number', fontSize: 18),
                SizedBox(height: 16),
                CommonAppInput(
                  textEditingController: controller.drugLic1Controller.value,
                  hintText: 'Drug License Number',
                  maxLength: 80,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: CommonFilePicker(
                          hintText: 'Upload Document 1',
                          selectedFilePath: controller.doc1File.value,
                          //onTap: () => controller.pickFile(1),
                          onTap: () => pickImage(1),
                          // Open Bottom Sheet
                          onClear: () => controller.clearFile(1),
                        ),
                      ),
                      //TODO : Expiry date 1
                      SizedBox(width: 10),
                      Expanded(
                        child: CommonDatePickerInput(
                          controller: controller.expireDate1Controller.value,
                          hintText: "DL Expiry Dt 1",
                          isEnabled: true,
                          onTap: () async {
                            Utils.closeKeyboard(context);
                            await AppDatePicker.allDateEnable(
                              context,
                              controller.expireDate1Controller.value,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.drugLicense2Visible.value,
                    child: SizedBox(height: 16),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.drugLicense2Visible.value,
                    child: CommonAppInput(
                      textEditingController:
                          controller.drugLic2Controller.value,
                      hintText: 'Drug License Number',
                      maxLength: 80,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.drugLicense2Visible.value,
                    child: SizedBox(height: 16),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.drugLicense2Visible.value,
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonFilePicker(
                            hintText: 'Upload Document 2',
                            selectedFilePath: controller.doc2File.value,
                            //onTap: () => controller.pickFile(2),
                            onTap: () => pickImage(2),
                            // Open Bottom Sheet
                            onClear: () => controller.clearFile(2),
                          ),
                        ),
                        //TODO : Expiry date 2
                        SizedBox(width: 10),
                        Expanded(
                          child: CommonDatePickerInput(
                            controller: controller.expireDate2Controller.value,
                            hintText: "DL Expiry Dt 2",
                            isEnabled: true,
                            onTap: () async {
                              Utils.closeKeyboard(context);
                              await AppDatePicker.allDateEnable(
                                context,
                                controller.expireDate2Controller.value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: '+Add More Drug License Number',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            controller.drugLicense2Visible.value =
                                !controller.drugLicense2Visible.value;
                          },
                    children: [
                      TextSpan(
                        text: ' (Max 2 DL)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          CommonDropdown(
            labelText: 'GST Type',
            hintText: 'Select GST Type',
            //initialValue: controller.selectedGstType.value,
            value: controller.selectedGstType.value,
            items: ['Regular', 'Composition', 'Exempted', 'None'],
            onChanged: (value) => controller.selectedGstType.value = value!,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.gstNoController.value,
            hintText: 'GST No',
            maxLength: 15,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              // Allow both lowercase and uppercase letters, and numbers
            ],
            // onChanged: (text) {
            //   // Automatically update PAN No based on GST No (only from 3rd to 12th character)
            //   text = text.toUpperCase(); // Convert the text to uppercase
            //
            //   controller.gstNoController.value.text =
            //       text; // Update the text in the controller
            //
            //   // Automatically update PAN No based on GST No (only from 3rd to 12th character)
            //   if (text.isEmpty) {
            //     controller.panNoController.value.clear();
            //   } else {
            //     if (text.length >= 3) {
            //       // Prevent RangeError by adjusting the substring length based on text length
            //       int endIndex =
            //           text.length >= 12
            //               ? 12
            //               : text
            //                   .length; // Ensure the endIndex is not greater than the length of text
            //       controller.panNoController.value.text = text.substring(
            //         2,
            //         endIndex,
            //       ); // Start from 3rd char (index 2) to 12th char (or endIndex)
            //
            //       // Move the cursor to the end after setting the value
            //       controller
            //           .panNoController
            //           .value
            //           .selection = TextSelection.collapsed(
            //         offset: controller.panNoController.value.text.length,
            //       );
            //     } else {
            //       controller.panNoController.value.clear();
            //     }
            //   }
            // },
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.panNoController.value,
            hintText: 'PAN No',
            textInputAction: TextInputAction.next,

            maxLength: 10,
            textCapitalization: TextCapitalization.characters,
            // Ensure the keyboard shows uppercase characters
            inputFormatters: [
              // Allow only uppercase characters and numbers
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              // Allow both lowercase and uppercase letters, and numbers
            ],
            // onChanged: (text) {
            //   text = text.toUpperCase(); // Convert the text to uppercase
            //   controller.panNoController.value.text =
            //       text; // Update the text in the controller
            // },
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.fssaiNoController.value,
            hintText: 'FSSAI No',
            maxLength: 80,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildStepForm(SignupController controller, int index) {
    switch (index) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep3(Get.context!);
      case 2:
        return _buildStep2(Get.context!);
      default:
        return const SizedBox();
    }
  }
}

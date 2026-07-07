import 'dart:io';

import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_images.dart';
import 'package:arham_b2c/widgets/common_text_button.dart';
import 'package:arham_b2c/models/state_response.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_image_svg.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common_dropdown.dart';
import '../../widgets/common_file_picker.dart';

import '../../widgets/terms_bottom_sheet_without_draggble.dart';
import 'signup_contoller.dart';

class SignupViewNew extends StatelessWidget {
  SignupViewNew({super.key});

  //final SignupController controller = Get.put(SignupController());

  final SignupController controller = Get.put(
    SignupController(),
    permanent: true,
  );

  final ImagePicker _picker = ImagePicker();

  Future<void> openPrivacyPolicy() async {
    final Uri url = Uri.parse("https://arhamcorp.in/privacy-policy");

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // forces browser
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: GlobalKey<FormState>(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isDark
                          ? Center(
                            child: CommonAppImageSvg(
                              imagePath: AppImages.icDarkB2CSvg,
                              height: 150,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          )
                          : Center(
                            child: CommonAppImageSvg(
                              imagePath: AppImages.icLightB2CSvg,
                              height: 150,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          ),
                      SizedBox(height: 16),
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
                            text: "Have an account?",
                            fontSize: AppDimensions.fontSizeMedium,
                            fontWeight: AppFontWeight.w400,
                          ),
                          SizedBox(
                            height: 35,
                            child: CommonTextButton(
                              title: 'Login',
                              onPressed: () {
                                Get.back();
                              },
                            ),
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
                      const SizedBox(height: 8),
                      CommonDropdown(
                        labelText: 'Business Type',
                        hintText: 'Select Business Type',
                        value: controller.selectedBusinessType.value,
                        items: [
                          'Chemist',
                          'Doctor',
                          'Hospital',
                          'General Store',
                        ],
                        onChanged:
                            (value) =>
                                controller.selectedBusinessType.value = value!,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.firmNameController.value,
                        hintText:
                            controller.selectedBusinessType.value + ' Name * ',
                        maxLength: 60,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.personNmController.value,
                        hintText: 'Person Name *',
                        maxLength: 60,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter the person\'s name'
                                    : null,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.clientCdController.value,
                        hintText: 'User ID *',
                        maxLength: 11,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter the user id'
                                    : null,
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () => CommonAppInput(
                          textInputAction: TextInputAction.done,
                          textEditingController:
                              controller.clientPwdController.value,
                          hintText: 'Password *',
                          maxLength: 20,
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
                              controller
                                  .toggleObscured, // Call function directly
                        ),
                      ),

                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.addressController.value,
                        hintText: 'Address *',
                        maxLength: 255,
                      ),
                      SizedBox(height: 16),
                      controller.isStateDropdownLoading.isTrue
                          ? Center(child: Utils.commonCircularProgress())
                          : TypeAheadField<StateModel>(
                            controller: controller.stateController.value,
                            focusNode: controller.stateFocus,
                            suggestionsCallback: (pattern) async {
                              return controller.stateList.value.data?.where((
                                item,
                              ) {
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
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              );
                            },
                            onSelected: (StateModel selectedItem) {
                              controller.selectedDropdownState.value =
                                  selectedItem;
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
                                controller: textController,
                                focusNode: focusNode,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  counter: const Offstage(),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 39,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            textController.clear();
                                            controller.stateFocus.unfocus();
                                            controller
                                                .selectedDropdownState
                                                .value = null;
                                            controller
                                                .selectedDropdownStateCD
                                                .value = '';
                                            controller
                                                .selectedDropdownStateName
                                                .value = '';
                                            controller.stateCdController.value
                                                .clear();
                                            controller.stateCDFocus.unfocus();
                                            Utils.closeKeyboard(Get.context!);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.close, size: 24),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 24,
                                          color: colorScheme.onSurface,
                                        ),
                                      ],
                                    ),
                                  ),
                                  labelText: 'Select State',
                                  labelStyle: TextStyle(
                                    color: colorScheme.onSurface,
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: colorScheme.outline,
                                      // Default themed outline color
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      // Highlight color when focused
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 18.0,
                                  ),
                                ),
                                style: TextStyle(color: colorScheme.onSurface),
                              );
                            },
                          ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController: controller.cityController.value,
                        hintText: 'City',
                        maxLength: 50,
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
                      CommonAppInput(
                        textEditingController:
                            controller.pinCodeController.value,
                        hintText: 'Pin Code',
                        maxLength: 6,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.mobile1Controller.value,
                        hintText: 'Mobile 1 *',
                        maxLength: 10,
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.mobile2Controller.value,
                        hintText: 'Mobile 2',
                        maxLength: 10,
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.emailIdController.value,
                        hintText: 'Email ID *',
                        maxLength: 255,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController: controller.zoneController.value,
                        hintText: 'Zone',
                        maxLength: 50,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController: controller.upiController.value,
                        hintText: 'UPI',
                        maxLength: 80,
                      ),
                      SizedBox(height: 16),
                      CommonDropdown(
                        labelText: 'GST Type',
                        hintText: 'Select GST Type',
                        //initialValue: controller.selectedGstType.value,
                        value: controller.selectedGstType.value,
                        items: ['Regular', 'Composition', 'Exempted', 'None'],
                        onChanged:
                            (value) =>
                                controller.selectedGstType.value = value!,
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController: controller.gstNoController.value,
                        hintText: 'GST No',
                        maxLength: 15,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z0-9]'),
                          ),
                          // Allow both lowercase and uppercase letters, and numbers
                        ],
                        onChanged: (text) {
                          // Automatically update PAN No based on GST No (only from 3rd to 12th character)
                          text =
                              text.toUpperCase(); // Convert the text to uppercase

                          controller.gstNoController.value.text =
                              text; // Update the text in the controller

                          // Automatically update PAN No based on GST No (only from 3rd to 12th character)
                          if (text.isEmpty) {
                            controller.panNoController.value.clear();
                          } else {
                            if (text.length >= 3) {
                              // Prevent RangeError by adjusting the substring length based on text length
                              int endIndex =
                                  text.length >= 12
                                      ? 12
                                      : text
                                          .length; // Ensure the endIndex is not greater than the length of text
                              controller
                                  .panNoController
                                  .value
                                  .text = text.substring(
                                2,
                                endIndex,
                              ); // Start from 3rd char (index 2) to 12th char (or endIndex)

                              // Move the cursor to the end after setting the value
                              controller
                                  .panNoController
                                  .value
                                  .selection = TextSelection.collapsed(
                                offset:
                                    controller
                                        .panNoController
                                        .value
                                        .text
                                        .length,
                              );
                            } else {
                              controller.panNoController.value.clear();
                            }
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController: controller.panNoController.value,
                        hintText: 'PAN No',
                        maxLength: 10,
                        textCapitalization: TextCapitalization.characters,
                        // Ensure the keyboard shows uppercase characters
                        inputFormatters: [
                          // Allow only uppercase characters and numbers
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z0-9]'),
                          ),
                          // Allow both lowercase and uppercase letters, and numbers
                        ],
                        onChanged: (text) {
                          text =
                              text.toUpperCase(); // Convert the text to uppercase
                          controller.panNoController.value.text =
                              text; // Update the text in the controller
                        },
                      ),
                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.fssaiNoController.value,
                        hintText: 'FSSAI No',
                        maxLength: 80,
                      ),
                      Visibility(
                        visible:
                            controller.selectedBusinessType.value == 'Doctor' ||
                            controller.selectedBusinessType.value ==
                                'Hospital' ||
                            controller.selectedBusinessType.value ==
                                'General Store',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            CommonText(
                              text: 'Add Registration Number',
                              fontSize: 18,
                            ),
                            SizedBox(height: 16),
                            CommonAppInput(
                              textEditingController:
                                  controller.registrationNo1Controller.value,
                              hintText: 'Registration No 1',
                              maxLength: 80,
                            ),
                            Visibility(
                              visible: controller.reg2Visible.value,
                              child: SizedBox(height: 16),
                            ),
                            Visibility(
                              visible: controller.reg2Visible.value,
                              child: CommonAppInput(
                                textEditingController:
                                    controller.registrationNo2Controller.value,
                                hintText: 'Registration No 2',
                                maxLength: 80,
                              ),
                            ),
                            SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: '+Add More Registration Number ',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        controller.reg2Visible.value =
                                            !controller.reg2Visible.value;
                                      },
                                children: [
                                  TextSpan(
                                    text: '(Max 2 RN)',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            controller.selectedBusinessType.value == 'Chemist',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            CommonText(
                              text: 'Upload Drug License Number',
                              fontSize: 18,
                            ),
                            SizedBox(height: 16),
                            CommonAppInput(
                              textEditingController:
                                  controller.drugLic1Controller.value,
                              hintText: 'Drug License Number',
                              maxLength: 80,
                            ),
                            SizedBox(height: 16),
                            Obx(
                              () => CommonFilePicker(
                                hintText: 'Upload Document 1',
                                selectedFilePath: controller.doc1File.value,
                                //onTap: () => controller.pickFile(1),
                                onTap: () => pickImage(1),
                                // Open Bottom Sheet
                                onClear: () => controller.clearFile(1),
                              ),
                            ),
                            //TODO : Expiry date 1
                            // SizedBox(height: 16),
                            // CommonDatePickerInput(
                            //   controller: controller.expireDate1Controller.value,
                            //   hintText: "Expiry Date",
                            //   isEnabled: true,
                            //   onTap: () async {
                            //     Utils.closeKeyboard(context);
                            //     await AppDatePicker.allDateEnable(
                            //       context,
                            //       controller.expireDate1Controller.value,
                            //     );
                            //   },
                            // ),
                            Visibility(
                              visible: controller.drugLicense2Visible.value,
                              child: SizedBox(height: 16),
                            ),
                            Visibility(
                              visible: controller.drugLicense2Visible.value,
                              child: CommonAppInput(
                                textEditingController:
                                    controller.drugLic2Controller.value,
                                hintText: 'Drug License Number',
                                maxLength: 80,
                              ),
                            ),
                            Visibility(
                              visible: controller.drugLicense2Visible.value,
                              child: SizedBox(height: 16),
                            ),
                            Visibility(
                              visible: controller.drugLicense2Visible.value,
                              child: Obx(
                                () => CommonFilePicker(
                                  hintText: 'Upload Document 2',
                                  selectedFilePath: controller.doc2File.value,
                                  //onTap: () => controller.pickFile(2),
                                  onTap: () => pickImage(2),
                                  // Open Bottom Sheet
                                  onClear: () => controller.clearFile(2),
                                ),
                              ),
                            ),

                            //TODO : Expiry date 2
                            // Visibility(
                            //   visible: controller.drugLicense2Visible.value,
                            //   child: SizedBox(height: 16),
                            // ),
                            // Visibility(
                            //   visible: controller.drugLicense2Visible.value,
                            //   child: CommonDatePickerInput(
                            //     controller: controller.expireDate2Controller.value,
                            //     hintText: "Expiry Date",
                            //     isEnabled: true,
                            //     onTap: () async {
                            //       Utils.closeKeyboard(context);
                            //       await AppDatePicker.allDateEnable(
                            //         context,
                            //         controller.expireDate2Controller.value,
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: '+Add More Drug License Number',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        controller.drugLicense2Visible.value =
                                            !controller
                                                .drugLicense2Visible
                                                .value;
                                      },
                                children: [
                                  TextSpan(
                                    text: ' (Max 2 DL)',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      CommonAppInput(
                        textEditingController:
                            controller.referralCodeController.value,
                        hintText: 'Referral Code (Optional)',
                        textInputAction: TextInputAction.done,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.characters,
                      ),

                      Obx(
                        () => CheckboxListTile(
                          // checkColor: AppColors.colorWhite,
                          // activeColor: AppColors.teal,
                          controlAffinity: ListTileControlAffinity.leading,
                          // Moves checkbox to right side
                          title: InkWell(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'By clicking Register, you have read and agreed to the ',
                                style: GoogleFonts.notoSans(
                                  fontSize: AppDimensions.fontSizeRegular,
                                  fontWeight: AppFontWeight.medium,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                //   color: Theme.of(context).colorScheme.onSurface, // theme-aware color
                                // ),
                                children: [
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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

                                            Get.to(
                                              () => Scaffold(
                                                appBar: AppBar(
                                                  title: const Text(
                                                    "Terms and Conditions",
                                                  ),
                                                ),
                                                body: BottomSheetWithWebViewWithoutDraggable(
                                                  url:
                                                      'https://arhamcorp.in/terms',
                                                ),
                                              ),
                                            );

                                            // Get.dialog(
                                            //   barrierDismissible: false,
                                            //   useSafeArea: true,
                                            //   Dialog(
                                            //     insetPadding: EdgeInsets.zero,
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(15),
                                            //     ),
                                            //     child: SizedBox(
                                            //       width:
                                            //           MediaQuery.of(
                                            //             context,
                                            //           ).size.width,
                                            //       height:
                                            //           MediaQuery.of(
                                            //             context,
                                            //           ).size.height *
                                            //           0.8,
                                            //       child: ClipRRect(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //               15,
                                            //             ),
                                            //         child: BottomSheetWithWebViewWithoutDraggable(
                                            //           url:
                                            //               'https://arhamcorp.in/terms',
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // );
                                          },
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: GoogleFonts.notoSans(
                                      fontSize: AppDimensions.fontSizeRegular,
                                      fontWeight: AppFontWeight.medium,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                    // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    //   color: Theme.of(context).colorScheme.onSurface, // theme-aware color
                                    // ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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

                                            Get.dialog(
                                              barrierDismissible: false,
                                              useSafeArea: true,
                                              Dialog(
                                                insetPadding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: SizedBox(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                  height:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.8,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                          },
                                  ),
                                  TextSpan(
                                    text: ' of B2C ',
                                    style: GoogleFonts.notoSans(
                                      fontSize: AppDimensions.fontSizeRegular,
                                      fontWeight: AppFontWeight.medium,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
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
                          onChanged:
                              (value) =>
                                  controller.termsAccepted.value = value!,
                        ),
                      ),

                      Obx(
                        () => CheckboxListTile(
                          // checkColor: AppColors.colorWhite,
                          // activeColor: AppColors.teal,
                          controlAffinity: ListTileControlAffinity.leading,
                          // Moves checkbox to right side
                          title: CommonText(
                            text:
                                'Yes, I would like to receive Transactional & Promotional materials',
                            //style: TextStyle(color: AppColors.colorDarkGray),
                          ),
                          value: controller.promotionalAgreed.value,
                          onChanged:
                              (value) =>
                                  controller.promotionalAgreed.value = value!,
                        ),
                      ),

                      SizedBox(height: 16),
                      Obx(
                        () => CommonButton(
                          buttonText: 'Sign Up',
                          onPressed: controller.signupValidation,
                          isLoading: controller.isSignupLoading.value,
                          isDisable: controller.isSignupDisable.value,
                        ),
                      ),
                      // SizedBox(height: 16),
                      // Center(
                      //   child: CommonTextButton(
                      //     onPressed: () => Get.offAll(() => LoginView()),
                      //     title: 'Already have an account? Login',
                      //     //style: TextStyle(color: AppColors.teal),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickImage(int docNumber) {
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

  void _setImageFile(int docNumber, File file) {
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
}

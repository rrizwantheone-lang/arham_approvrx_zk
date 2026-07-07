import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/models/state_response.dart';
import 'package:arham_b2c/screens/profile/profile_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_banner.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/common_dropdown.dart';

class ProfileNewView extends StatelessWidget {
  ProfileNewView({super.key});

  //final SignupController controller = Get.put(SignupController());

  final ProfileController controller = Get.put(ProfileController());

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Profile',
        actions: [
          // Obx(
          //   () => Visibility(
          //     visible:
          //         (controller.mainList.value.data?.isNotEmpty ?? false) &&
          //         !controller.isTextField.value,
          //     child: IconButton(
          //       onPressed: () {
          //         controller.isTextField.value = true;
          //         // AppSnackBar.showGetXCustomSnackBar(
          //         //     message: 'Coming soon...');
          //       },
          //       icon: const Icon(Icons.edit), // The "Add" icon
          //     ),
          //   ),
          // ),
          Obx(
                () => Visibility(
              visible: controller.hasProfile.isTrue &&
                  controller.isTextField.isFalse,
              child: IconButton(
                onPressed: () {
                  controller.isTextField.value = true;
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.isTextField.value,
              child: IconButton(
                onPressed: () {
                  controller.isTextField.value = false;
                },
                icon: const Icon(
                  Icons.close, // The "Add" icon
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(child: _getView(context)),
                const Visibility(visible: true, child: SizedBox(height: 20)),
                Visibility(
                  visible: controller.isTextField.value,
                  child: CommonButton(
                    buttonText: 'Update',
                    onPressed: controller.signupValidation,
                    isLoading: controller.isUpdateLoading.value,
                    isDisable: controller.isDisable.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _getView1(BuildContext context) {
    return controller.isLoading.isTrue
        ? Center(child: Utils.commonCircularProgress())
        : (controller.mainList.value.data == null ||
            controller.mainList.value.data!.isEmpty)
        ? Center(
          child: CommonText(
            text: 'No record found',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        )
        : _addProfileView(context);
  }

  Widget _getView(BuildContext context) {
    return controller.isLoading.isTrue
        ? Center(child: Utils.commonCircularProgress())
        : controller.hasProfile.isFalse
        ? Center(
      child: CommonText(
        text: 'No record found',
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    )
        : _addProfileView(context);
  }

  Widget _addProfileView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Vertical Centering
        crossAxisAlignment: CrossAxisAlignment.start,
        // Horizontal Centering
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          CommonDropdown(
            labelText: 'Business Type',
            hintText: 'Select Business Type',
            value: controller.selectedBusinessType.value,
            items: ['Chemist', 'Doctor', 'Hospital'],
            onChanged:
                (value) => controller.selectedBusinessType.value = value!,
            isEnabled: false, // true = enabled, false = disabled
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.firmNameController.value,
            hintText: 'Distributor Name * ',
            maxLength: 60,
            //isEnable: controller.isTextField.value,
            isEnable: false,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.personNmController.value,
            hintText: 'Person Name *',
            isEnable: controller.isTextField.value,
            textInputAction: TextInputAction.next,
            maxLength: 60,
            validator:
                (value) =>
                    value!.isEmpty ? 'Please enter the person\'s name' : null,
          ),
          SizedBox(height: 16),
          Visibility(
            visible: true,
            child: CommonAppInput(
              textEditingController: controller.clientCdController.value,
              hintText: 'Client CD *',
              maxLength: 11,
              isEnable: false,
              validator:
                  (value) =>
                      value!.isEmpty ? 'Please enter the client code' : null,
            ),
          ),
          Visibility(visible: true, child: SizedBox(height: 16)),
          Visibility(
            visible: false,
            child: Obx(
              () => CommonAppInput(
                textInputAction: TextInputAction.done,
                textEditingController: controller.clientPwdController.value,
                hintText: 'Client Password *',
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
                    controller.toggleObscured, // Call function directly
              ),
            ),
          ),
          Visibility(visible: false, child: SizedBox(height: 16)),

          CommonAppInput(
            textEditingController: controller.addressController.value,
            hintText: 'Address *',
            maxLength: 255,
            //isEnable: controller.isTextField.value,
            isEnable: false,
          ),
          SizedBox(height: 16),
          controller.isDropdownLoading.isTrue
              ? Center(child: Utils.commonCircularProgress())
              : AbsorbPointer(
                //absorbing: controller.isTextField.value,
                child: TypeAheadField<StateModel>(
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
                                  controller.selectedDropdownStateName.value =
                                      '';
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
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
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
                      //style: TextStyle(color: colorScheme.onSurface),
                    );
                  },
                ),
              ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.cityController.value,
            hintText: 'City',
            maxLength: 50,
            //isEnable: controller.isTextField.value,
            isEnable: false,
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
            textEditingController: controller.pinCodeController.value,
            hintText: 'Pin Code',
            maxLength: 6,
            //isEnable: controller.isTextField.value,
            isEnable: false,
            textInputType: TextInputType.number,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.mobile1Controller.value,
            hintText: 'Mobile 1 *',
            maxLength: 10,
            //isEnable: controller.isTextField.value,
            isEnable: false,
            textInputType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.mobile2Controller.value,
            hintText: 'Mobile 2',
            maxLength: 10,
            textInputAction: TextInputAction.next,
            isEnable: controller.isTextField.value,
            textInputType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.emailIdController.value,
            hintText: 'Email ID',
            //isEnable: controller.isTextField.value,
            isEnable: false,
            maxLength: 255,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.zoneController.value,
            hintText: 'Zone',
            maxLength: 50,
            textInputAction: TextInputAction.next,
            isEnable: controller.isTextField.value,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.upiController.value,
            hintText: 'UPI',
            maxLength: 80,
            textInputAction: TextInputAction.next,
            isEnable: controller.isTextField.value,
          ),
          SizedBox(height: 16),
          CommonDropdown(
            labelText: 'GST Type',
            hintText: 'Select GST Type',
            //initialValue: controller.selectedGstType.value,
            value: controller.selectedGstType.value,
            items: ['Regular', 'Composition', 'Exempted', 'None'],
            onChanged: (value) => controller.selectedGstType.value = value!,
            isEnabled: false,
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.gstNoController.value,
            hintText: 'GST No',
            maxLength: 15,
            isEnable: false,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              // Allow both lowercase and uppercase letters, and numbers
            ],
            onChanged: (text) {
              // Automatically update PAN No based on GST No (only from 3rd to 12th character)
              text = text.toUpperCase(); // Convert the text to uppercase

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
                  controller.panNoController.value.text = text.substring(
                    2,
                    endIndex,
                  ); // Start from 3rd char (index 2) to 12th char (or endIndex)

                  // Move the cursor to the end after setting the value
                  controller
                      .panNoController
                      .value
                      .selection = TextSelection.collapsed(
                    offset: controller.panNoController.value.text.length,
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
            isEnable: controller.isTextField.value,
            textCapitalization: TextCapitalization.characters,
            // Ensure the keyboard shows uppercase characters
            inputFormatters: [
              // Allow only uppercase characters and numbers
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              // Allow both lowercase and uppercase letters, and numbers
            ],
            onChanged: (text) {
              text = text.toUpperCase(); // Convert the text to uppercase
              controller.panNoController.value.text =
                  text; // Update the text in the controller
            },
          ),
          SizedBox(height: 16),
          CommonAppInput(
            textEditingController: controller.fssaiNoController.value,
            hintText: 'FSSAI No',
            maxLength: 80,
            textInputAction: TextInputAction.done,
            isEnable: controller.isTextField.value,
          ),
          Visibility(
            visible:
                controller.selectedBusinessType.value == 'Doctor' ||
                controller.selectedBusinessType.value == 'Hospital' ||
                controller.selectedBusinessType.value == 'General Store',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonText(
                  text: 'Add Registration Number',
                  fontSize: 18,
                  color: AppColors.colorDarkGray,
                ),
                SizedBox(height: 16),
                CommonAppInput(
                  textEditingController:
                      controller.registrationNo1Controller.value,
                  hintText: 'Registration No 1',
                  maxLength: 80,
                  //isEnable: controller.isTextField.value,
                  isEnable: false,
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
                    isEnable: controller.isTextField.value,
                  ),
                ),
                SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: '+Add More Registration Number ',
                    style: TextStyle(
                      color: AppColors.teal,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
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
                        style: TextStyle(
                          color: AppColors.colorDarkGray,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
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
                (controller.selectedBusinessType.value == 'Medical' ||
                    controller.selectedBusinessType.value == 'Chemist'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonText(
                  text: 'Upload Drug License Number',
                  fontSize: 18,
                  color: AppColors.colorDarkGray,
                ),
                Visibility(visible: true, child: SizedBox(height: 16)),
                Visibility(
                  visible: true,
                  child: CommonAppInput(
                    textEditingController: controller.drugLic1Controller.value,
                    hintText: 'Drug License Number',
                    maxLength: 80,
                    //isEnable: controller.isTextField.value,
                    isEnable: false,
                  ),
                ),
                Visibility(visible: false, child: SizedBox(height: 16)),
                // Visibility(
                //   visible: false,
                //   child: Obx(
                //     () => CommonFilePicker(
                //       hintText: 'Upload Document 1',
                //       selectedFilePath: controller.doc1Path.value,
                //       //onTap: () => controller.pickFile(1),
                //       onTap: () => pickImage(1),
                //       // Open Bottom Sheet
                //       onClear: () => controller.clearFile(1),
                //     ),
                //   ),
                // ),
                //TODO : Expiry date 1
                // Visibility(visible:true,child: SizedBox(height: 16)),
                // Visibility(
                //   visible: true,
                //   child: CommonDatePickerInput(
                //     controller: controller.expireDate1Controller.value,
                //     hintText: "Expiry Date",
                //     isEnabled: false,
                //     onTap: () async {
                //       Utils.closeKeyboard(context);
                //       await AppDatePicker.allDateEnable(
                //         context,
                //         controller.expireDate1Controller.value,
                //       );
                //     },
                //   ),
                // ),
                Visibility(
                  visible: controller.drugLicense2Visible.value,
                  child: SizedBox(height: 16),
                ),
                Visibility(
                  visible: controller.drugLicense2Visible.value,
                  child: CommonAppInput(
                    textEditingController: controller.drugLic2Controller.value,
                    hintText: 'Drug License Number',
                    maxLength: 80,
                    //isEnable: controller.isTextField.value,
                    isEnable: false,
                  ),
                ),
                Visibility(
                  //visible: controller.drugLicense2Visible.value,
                  visible: false,
                  child: SizedBox(height: 16),
                ),
                // Visibility(
                //   //visible: controller.drugLicense2Visible.value,
                //   visible: false,
                //   child: Obx(
                //     () => CommonFilePicker(
                //       hintText: 'Upload Document 2',
                //       selectedFilePath: controller.doc2Path.value,
                //       //onTap: () => controller.pickFile(2),
                //       onTap: () => pickImage(2),
                //       // Open Bottom Sheet
                //       onClear: () => controller.clearFile(2),
                //     ),
                //   ),
                // ),
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
                Visibility(visible: false, child: SizedBox(height: 16)),
                Visibility(
                  visible: false,
                  child: RichText(
                    text: TextSpan(
                      text: '+Add More Drug License Number',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              controller.drugLicense2Visible.value =
                                  !controller.drugLicense2Visible.value;
                            },
                      children: [
                        TextSpan(
                          text: '(Max 2 DL)',
                          style: TextStyle(
                            color: AppColors.colorDarkGray,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CommonCarouselBanner(
                  images: controller.bannerListData,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          // SizedBox(height: 16),
          //
          // Obx(
          //   () => Visibility(
          //     visible: controller.isTextField.value,
          //     child: CommonButton(
          //       buttonText: 'Update',
          //       onPressed: controller.signupValidation,
          //       isLoading: controller.isLoading.value,
          //       isDisable: controller.isDisable.value,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void pickImage(int docNumber) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.teal),
              title: Text("Take Photo"),
              onTap: () async {
                Get.back(); // Close Bottom Sheet
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedFile != null) {
                  _setImagePath(docNumber, pickedFile.path);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.teal),
              title: Text("Choose from Gallery"),
              onTap: () async {
                Get.back(); // Close Bottom Sheet
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  _setImagePath(docNumber, pickedFile.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setImagePath(int docNumber, String path) {
    if (docNumber == 1) {
      controller.doc1Path.value = path;
    } else if (docNumber == 2) {
      controller.doc2Path.value = path;
    }
  }

  void clearFile(int docNumber) {
    if (docNumber == 1) {
      controller.doc1Path.value = '';
    } else if (docNumber == 2) {
      controller.doc2Path.value = '';
    }
  }
}

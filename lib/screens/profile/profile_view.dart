import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/screens/profile/profile_controller.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(
    ProfileController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Profile',
        actions: [
          Obx(
            () => Visibility(
              visible: !controller.isTextField.value,
              child: IconButton(
                onPressed: () {
                  controller.isTextField.value = true;
                  // AppSnackBar.showGetXCustomSnackBar(
                  //     message: 'Coming soon...');
                },
                icon: const Icon(Icons.edit), // The "Add" icon
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
      body: Obx(
        () => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(child: _addProfileView(context)),
              const Visibility(visible: true, child: SizedBox(height: 20)),
              Visibility(
                visible: controller.isTextField.value,
                child: CommonButton(
                  buttonText: 'Update',
                  onPressed: () {},
                  isLoading: controller.isLoading.value,
                  isDisable: controller.isDisable.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addProfileView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userDetails(),
          Visibility(
            visible: PreferenceUtils.getLoginUserRole() == 'M',
            child: const SizedBox(height: 20),
          ),
          Visibility(
            visible: PreferenceUtils.getLoginUserRole() == 'M',
            child: _licenceDetails(),
          ),
        ],
      ),
    );
  }

  Widget _userDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'User Details : ',
          fontSize: 24,
          fontWeight: AppFontWeight.w500,
        ),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.userCdController.value,
          hintText: "User Code",
          isEnable: controller.isTextField.value,
          focusNode: controller.userCDFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.userNameController.value,
          hintText: "User Name",
          isEnable: controller.isTextField.value,
          focusNode: controller.userNameFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.userTypeController.value,
          hintText: "User Type",
          isEnable: controller.isTextField.value,
          focusNode: controller.userTypeFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.mobileNoController.value,
          hintText: "Mobile No",
          isEnable: controller.isTextField.value,
          focusNode: controller.mobileNoFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.done,
          textEditingController: controller.firmNameController.value,
          hintText: "Distributor Name",
          isEnable: controller.isTextField.value,
          focusNode: controller.firmFocus,
        ),
      ],
    );
  }

  Widget _licenceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Licence Details : ',
          color: AppColors.colorTeal,
          fontSize: 24,
          fontWeight: AppFontWeight.w500,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.licenceExpireDaysController.value,
          hintText: "Licence Expire Days",
          isEnable: controller.isTextField.value,
          focusNode: controller.licenceExpireDaysFocus,
          labelStyle: const TextStyle(color: AppColors.colorRed),
          hintStyle: const TextStyle(color: AppColors.colorDarkBlue),
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.licenceStartDtController.value,
          hintText: "Licence Start Dt",
          isEnable: controller.isTextField.value,
          focusNode: controller.licenceStartDtFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.licenceEndDtController.value,
          hintText: "Licence End Dt",
          focusNode: controller.licenceEndDtFocus,
          isEnable: controller.isTextField.value,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.licenceRenewalDtController.value,
          hintText: "Licence Renewal Dt",
          isEnable: controller.isTextField.value,
          focusNode: controller.licenceRenewalDtFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.next,
          textEditingController: controller.maxFirmsController.value,
          hintText: "Max Firms",
          isEnable: controller.isTextField.value,
          focusNode: controller.maxFirmsFocus,
        ),
        const SizedBox(height: 15),
        CommonAppInput(
          textInputAction: TextInputAction.done,
          textEditingController: controller.maxUserController.value,
          hintText: "Max Users",
          isEnable: controller.isTextField.value,
          focusNode: controller.maxUsersFocus,
        ),
      ],
    );
  }
}

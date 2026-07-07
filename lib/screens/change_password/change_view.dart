import 'package:arham_b2c/screens/change_password/change_controller.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/common_app_input.dart';

class ChangeView extends StatelessWidget {
  ChangeView({super.key});

  final ChangeController controller = Get.put(ChangeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Change Password'),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(
                  () => CommonAppInput(
                    focusNode: controller.currentFocus,
                nextFocusNode: controller.newFocus,
                textInputAction: TextInputAction.next,
                textEditingController: controller.currentPasswordController,
                hintText: 'Current Password *',
                maxLength: 12,
                isEnable: true,
                isPassword: controller.isCurrentObscured.value,
                // Use obscureText
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                suffixIcon:
                controller.isCurrentObscured.value
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                onSuffixClick:
                controller.toggleCurrent, // Call function directly
              ).paddingOnly(top: 16),
            ),
            SizedBox(height: 20),
            Obx(
                  () => CommonAppInput(
                    focusNode: controller.newFocus,
                nextFocusNode: controller.confirmFocus,
                textInputAction: TextInputAction.next,
                textEditingController: controller.newPasswordController,
                hintText: 'New Password *',
                maxLength: 12,
                isEnable: true,
                isPassword: controller.isNewObscured.value,
                // Use obscureText
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
                suffixIcon:
                controller.isNewObscured.value
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                onSuffixClick:
                controller.toggleNew, // Call function directly
              ).paddingOnly(top: 16),
            ),
            SizedBox(height: 20),
            Obx(
                  () => CommonAppInput(
                    focusNode: controller.confirmFocus,
                textInputAction: TextInputAction.done,
                textEditingController: controller.confirmPasswordController,
                hintText: 'Confirm Password *',
                maxLength: 12,
                isEnable: true,
                isPassword: controller.isConfirmObscured.value,
                // Use obscureText
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  return null;
                },
                suffixIcon:
                controller.isConfirmObscured.value
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                onSuffixClick:
                controller.toggleConfirm, // Call function directly
              ).paddingOnly(top: 16),
            ),
            SizedBox(height: 30),
            CommonButton(
              buttonText: 'Change Password',
              onPressed: (){
                if(controller.isDisable.value){
                  return;
                }
                controller.validateAndChangePassword();
              },
              isLoading: controller.isLoading.value,
              isDisable: controller.isDisable.value,
            ),
          ],
        ),
      ),
    );
  }
}

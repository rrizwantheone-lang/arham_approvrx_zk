import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../outstanding/outstanding_controller.dart';
import '../sales_register/sales_register_controller.dart';

class ReportsController extends GetxController {
  // ─────────────────────────────────────────────
  // Shared filter fields
  // ─────────────────────────────────────────────
  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;
  Rx<TextEditingController> firmController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();
  FocusNode firmFocus = FocusNode();

  RxBool showFilters = false.obs; // controlled by toggle icon

  var isDropdownFirmLoading = false.obs;
  Rx<FirmResponse> firmList = FirmResponse().obs;
  final Rx<FirmModel?> selectedDropdownFirm = Rx<FirmModel?>(null);
  RxString selectedDropdownFirmCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
    toDateController.value.text = AppDatePicker.currentDate();
    fetchFirm();
  }

  Future<void> fetchFirm() async {
    if (await Network.isConnected()) {
      try {
        isDropdownFirmLoading(true);

        var response = await DioClient().get(AppURL.dropdownFirmURL);

        firmList.value = FirmResponse.fromJson(response);
        if (firmList.value.data != null && firmList.value.data!.isNotEmpty) {
          if (firmList.value.message == 'Data fetch successfully') {
            if (firmList.value.data!.length == 1) {
              var selectedFirm = firmList.value.data!.first;
              selectedDropdownFirm.value = selectedFirm;
              selectedDropdownFirmCode.value = selectedFirm.syncId.toString().trim();
              firmController.value.text = selectedFirm.firmName.trim();
              Utils.closeKeyboard(Get.context!);
              firmFocus.unfocus();
              refreshAllReports();
            }
          } else {
            AppSnackBar.showGetXCustomSnackBar(message: response.data['message'] ?? 'Failed to load firms');
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No distributor found');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isDropdownFirmLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  void refreshAllReports() {
    // Trigger refresh in child controllers
    if (Get.isRegistered<SalesRegisterController>()) {
      Get.find<SalesRegisterController>().fetchSalesRegister();
    }
    if (Get.isRegistered<OutstandingController>()) {
      Get.find<OutstandingController>().fetchOutstanding();
    }
  }

  @override
  void onClose() {
    fromDateController.value.dispose();
    toDateController.value.dispose();
    firmController.value.dispose();
    fromDtFocus.dispose();
    toDtFocus.dispose();
    firmFocus.dispose();
    super.onClose();
  }
}
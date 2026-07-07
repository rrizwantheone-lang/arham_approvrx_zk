import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_date_format.dart';
import '../../models/firm_response.dart';

class ReportsFilterController extends GetxController{
  final Rx<FirmModel?> selectedFirm = Rx<FirmModel?>(null);
  final RxString selectedFirmCode = ''.obs;

  final RxString fromDate = ''.obs;
  final RxString toDate = ''.obs;

  final RxBool showFirmDropdown = true.obs;

  final RxBool showFilterSection = false.obs;

  final TextEditingController firmTextController = TextEditingController();

  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Default dates (single source of truth)
    fromDate.value = AppDatePicker.firstDayFinancialYear();
    toDate.value = AppDatePicker.currentDate();
  }

  void setTabIndex(int index) {
    currentTabIndex.value = index;
  }

  @override
  void onClose() {
    firmTextController.dispose();
    super.onClose();
  }

  void setFirm(FirmModel firm) {
    selectedFirm.value = firm;
    selectedFirmCode.value = firm.syncId.toString().trim();
    firmTextController.text = firm.firmName.trim();

    showFirmDropdown.value = false;
  }

  void clearFirm() {
    selectedFirm.value = null;
    selectedFirmCode.value = '';
    firmTextController.clear();

    showFirmDropdown.value = true;
  }

  void setFromDate(String date) {
    fromDate.value = date;
  }

  void setToDate(String date) {
    toDate.value = date;
  }



  void toggleFilterSection() {
    showFilterSection.value = !showFilterSection.value;

    showFirmDropdown.value = true;
  }

  // Optional: reset when changing tabs / firm
  void resetFilterVisibility() {
    showFilterSection.value = false;
  }


}
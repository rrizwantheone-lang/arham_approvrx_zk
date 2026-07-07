import 'package:get/get.dart';
import 'package:arham_b2c/utility/preference_utils.dart';

class SettingsController extends GetxController {

  RxString personName = ''.obs;
  RxString firmName = ''.obs;
  RxString businessType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    personName.value =
        PreferenceUtils.getLoginUserName() ?? '';

    firmName.value =
        PreferenceUtils.getFirmName() ?? '';

    // businessType.value =
    //     PreferenceUtils.getFirmGSTType() ?? '';
  }

  void refreshData() {
    loadUserData();
  }
}
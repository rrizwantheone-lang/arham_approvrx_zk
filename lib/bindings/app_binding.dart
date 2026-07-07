import 'package:arham_b2c/screens/home/home_controller.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../screens/reports/reports_filter_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReportsFilterController>(
      ReportsFilterController(),
      permanent: true,
    );

    // Get.put(HomeController(), permanent: true);
    Get.put(BottomNavController(), permanent: true);

  }
}
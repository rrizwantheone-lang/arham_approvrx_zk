import 'package:get/get.dart';
import '../screens/reports/reports_filter_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsFilterController>(
          () => ReportsFilterController(),
      fenix: true,
    );
  }
}
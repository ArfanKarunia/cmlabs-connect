import 'package:get/get.dart';

import 'analytics_controller.dart';

class AnalyticsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnalyticsController());
  }
}

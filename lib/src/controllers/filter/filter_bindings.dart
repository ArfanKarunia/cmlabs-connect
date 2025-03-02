import 'package:get/get.dart';

import 'filter_controller.dart';

class FilterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterController(), fenix: true);
  }
}

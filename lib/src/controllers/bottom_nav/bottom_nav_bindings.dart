import 'package:get/get.dart';

import 'bottom_nav_controller.dart';

class BottomNavBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController());
  }
}

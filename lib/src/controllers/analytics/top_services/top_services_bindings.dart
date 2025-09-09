import 'package:get/get.dart';

import 'top_services_controller.dart';

class TopServicesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopServicesController(), fenix: true);
  }
}

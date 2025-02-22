import 'package:get/get.dart';

import 'authentication_controller.dart';

class AuthenticationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController());
  }
}

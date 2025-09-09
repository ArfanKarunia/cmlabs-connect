import 'package:get/get.dart';

import 'top_pics_controller.dart';

class TopPICsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopPICsController(), fenix: true);
  }
}

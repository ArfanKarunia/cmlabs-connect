import 'package:get/get.dart';

import 'quotation_controller.dart';

class QuotationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuotationController());
  }
}

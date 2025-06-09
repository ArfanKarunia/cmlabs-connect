import 'package:get/get.dart';

import 'quotation_trends_controller.dart';

class QuotationTrendsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuotationTrendsController());
  }
}

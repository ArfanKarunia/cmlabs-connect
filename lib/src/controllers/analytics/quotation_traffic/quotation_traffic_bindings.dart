import 'package:get/get.dart';

import 'quotation_traffic_controller.dart';

class QuotationTrafficBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuotationTrafficController(), fenix: true);
  }
}

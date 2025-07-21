import 'package:get/get.dart';

import 'historical_lead_controller.dart';

class HistoricalLeadBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoricalLeadController(), fenix: true);
  }
}

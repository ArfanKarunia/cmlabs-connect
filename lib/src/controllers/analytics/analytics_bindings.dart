import 'package:get/get.dart';

import 'analytics_controller.dart';
import 'quotation_traffic/quotation_traffic_bindings.dart';
import 'quotation_trends/quotation_trends_bindings.dart';
import 'top_pics/top_pics_bindings.dart';
import 'top_services/top_services_bindings.dart';

class AnalyticsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnalyticsController(), fenix: true);

    QuotationTrafficBindings().dependencies();
    TopServicesBindings().dependencies();
    TopPICsBindings().dependencies();
    QuotationTrendsBindings().dependencies();
  }
}

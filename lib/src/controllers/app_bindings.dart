import 'package:get/get.dart';

import 'authentication_controller.dart';
import 'bottom_nav_controller.dart';
import 'case_studies/case_studies_bindings.dart';
import 'quotation/quotation_bindings.dart';
import 'user_controler.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(UserControler());
    Get.put(AuthenticationController());
    Get.put(BottomNavController());

    QuotationBindings().dependencies();
    CaseStudiesBindings().dependencies();
  }
}

import 'package:get/get.dart';

import 'authentication/authentication_bindings.dart';
import 'bottom_nav/bottom_nav_bindings.dart';
import 'inbox/case_studies/case_studies_bindings.dart';
import 'inbox/quotation/quotation_bindings.dart';
import 'user_controler.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(UserControler());
    AuthenticationBindings().dependencies();
    BottomNavBindings().dependencies();

    QuotationBindings().dependencies();
    CaseStudiesBindings().dependencies();
  }
}

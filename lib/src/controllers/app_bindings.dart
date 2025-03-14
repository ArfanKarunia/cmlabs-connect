import 'package:get/get.dart';

import 'authentication/authentication_bindings.dart';
import 'bottom_nav/bottom_nav_bindings.dart';
import 'inbox/case_studies/case_studies_bindings.dart';
import 'inbox/quotation/quotation_bindings.dart';
import 'user/user_bindings.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    UserBindings().dependencies();
    AuthenticationBindings().dependencies();
    BottomNavBindings().dependencies();

    QuotationBindings().dependencies();
    CaseStudiesBindings().dependencies();
  }
}

import 'package:get/get.dart';

import 'case_studies/case_studies_bindings.dart';
import 'contact_us/contact_us_bindings.dart';
import 'faq/faq_bindings.dart';
import 'quotation/quotation_bindings.dart';

class InboxBindings extends Bindings {
  @override
  void dependencies() {
    QuotationBindings().dependencies();
    CaseStudiesBindings().dependencies();
    ContactUsBindings().dependencies();
    FaqBindings().dependencies();
  }
}

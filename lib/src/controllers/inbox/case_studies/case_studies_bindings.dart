import 'package:get/get.dart';

import 'case_studies_controller.dart';

class CaseStudiesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CaseStudiesController());
  }
}

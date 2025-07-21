import 'package:get/get.dart';

import 'case_studies_controller.dart';
import 'detail_case_studies_controller.dart';
import 'edit_case_studies_controller.dart';
import 'edit_history_case_studies_controller.dart';

class CaseStudiesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CaseStudiesController(), fenix: true);
    Get.lazyPut(() => DetailCaseStudiesController(), fenix: true);
    Get.lazyPut(() => EditCaseStudiesController(), fenix: true);
    Get.lazyPut(() => EditHistoryCaseStudiesController(), fenix: true);
  }
}

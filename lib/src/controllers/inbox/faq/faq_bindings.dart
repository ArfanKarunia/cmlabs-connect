import 'package:get/get.dart';

import 'detail_faq_controller.dart';
import 'edit_faq_controller.dart';
import 'faq_controller.dart';

class FaqBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqController());
    Get.lazyPut(() => DetailFaqController(), fenix: true);
    Get.lazyPut(() => EditFaqController(), fenix: true);
  }
}

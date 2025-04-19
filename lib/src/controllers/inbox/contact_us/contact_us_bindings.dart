import 'package:get/get.dart';

import 'contact_us_controller.dart';
import 'detail_contact_us_controller.dart';
import 'edit_contact_us_controller.dart';
import 'edit_history_contact_us_controller.dart';

class ContactUsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactUsController());
    Get.lazyPut(() => DetailContactUsController(), fenix: true);
    Get.lazyPut(() => EditContactUsController(), fenix: true);
    Get.lazyPut(() => EditHistoryContactUsController(), fenix: true);
  }
}

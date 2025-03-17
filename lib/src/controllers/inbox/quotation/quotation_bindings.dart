import 'package:get/get.dart';

import '../../edit_quotation/client_pic_contact_controller.dart';
import 'add_quotation_controller.dart';
import 'quotation_controller.dart';

class QuotationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuotationController());
    Get.lazyPut(() => AddQuotationController(), fenix: true);
    Get.lazyPut(() => ClientPicContactController(), fenix: true);
  }
}

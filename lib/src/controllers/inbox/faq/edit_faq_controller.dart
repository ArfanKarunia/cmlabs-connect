
import 'package:get/get.dart';

import '../../../utils/toast.dart';
import '../edit_form_controller.dart';
import 'package:dio/dio.dart' as http;

import 'detail_faq_controller.dart';
import 'faq_controller.dart';

class EditFaqController extends EditFormController {
  final parentController = Get.find<FaqController>();
  final detailController = Get.find<DetailFaqController>();

  @override
  void onReady() {
    fetchStatus();
  }

  Future<void> submitStatusFaq(int id) async {
    try {
      isLoading(true);

      final response = await dio.post(
        '$baseUrl/faq/$id/update-status/',
        data: {'status': selectedStatus.value?['value']},
        options: http.Options(
          headers: {
            // 'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );


      isLoading(false);
      if (response.statusCode == 200 && response.data['success']) {
        final index = parentController.faqList.indexWhere((faq) => faq.id == id);
        if (index != -1) {
          parentController.faqList[index] = parentController.faqList[index].copyWith(
            status: int.tryParse('${selectedStatus.value?['value']}'),
          );
        }
        detailController.faq.value = detailController.faq.value?.copyWith(
          status: int.tryParse('${selectedStatus.value?['value']}'),
        );
        showSuccessToast('Berhasil mengubah status FAQ!');
        Get.back();
      } else {
        Get.snackbar('Error', 'An error occured', duration: const Duration(seconds: 1));
      }
    } on http.DioException catch (e) {
      isLoading(false);
      showErrorToast('Error: ${e.response?.data}');
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }
}

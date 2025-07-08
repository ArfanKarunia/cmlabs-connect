import 'dart:io';

import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';

import '../../../utils/toast.dart';
import '../edit_history_controller.dart';
import 'edit_quotation_controller.dart';

class EditHistoryQuotationController extends EditHistoryController {
  final parentController = Get.find<EditQuotationController>();

  @override
  Future<void> submitHistory({required int id, File? file}) async {
    try {
      isLoading(true);

      final isFormValid = await validateForm(file);
      if (!isFormValid) {
        isLoading(false);
        return;
      }

      final fields = {
        "id": id,
        "name": activityName.value.text,
        for (int i = 0; i < activityType.length; i++) "type[$i]": activityType[i]['value'],
        "note": activityNote.value.text,
        "available_to_user": availableToUser.value == true ? 1 : 0,
        if (file != null) "file": await http.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      };

      http.FormData data = http.FormData.fromMap(fields);

      final response = await dio.post(
        '$baseUrl/quotation/update_history_byId',
        data: data,
        options: http.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );

      isLoading(false);

      if (response.statusCode == 200) {
        final index = parentController.historyList.indexWhere((history) => history.id == id);

        if (index != -1) {
          parentController.historyList[index] = parentController.historyList[index].copyWith(
            id: id,
            name: activityName.value.text,
            type: activityType.map((type) => type['value'] ?? '').toList(),
            note: activityNote.value.text,
            availableToUser: availableToUser.value,
            file: file?.path.split('/').last,
          );
        }
        showSuccessToast('Berhasil mengubah Project History!');
        Get.back();
      }
    } on http.DioException catch (e) {
      isLoading(false);
      final errors = e.response?.data['message'];
      // Get.snackbar('Error', errors);

      if (errors is Map) {
        errors.forEach(
          (key, value) {
            if (value is List) {
              for (var errorMessage in value) {
                Get.snackbar('Error', errorMessage, duration: const Duration(seconds: 1));
              }
            } else {
              Get.snackbar('Error', value, duration: const Duration(seconds: 1));
            }
          },
        );
      } else {
        Get.snackbar('Error', errors, duration: const Duration(seconds: 1));
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }
}

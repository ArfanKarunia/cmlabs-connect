import 'dart:io';

import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';

import '../../../models/inbox/property/project_history_model.dart';
import '../../../utils/toast.dart';
import '../edit_history_controller.dart';
import 'edit_case_studies_controller.dart';

class EditHistoryCaseStudiesController extends EditHistoryController {
  final parentController = Get.find<EditCaseStudiesController>();

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
        "name": activityName.value.text,
        "type": activityType.map((type) => type['value']).toList(),
        "note": activityNote.value.text,
        "available_to_user": availableToUser.value == true ? 1 : 0,
        if (file != null) "file": await http.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      };

      http.FormData data = http.FormData.fromMap(fields);

      final response = await dio.post(
        '$baseUrl/case-studies/update-history-activity/$id',
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
        final newData = ProjectHistory.fromJson(response.data['data']);

        if (index != -1) {
          parentController.historyList[index] = newData;
        }
        showSuccessToast('Berhasil mengubah Project History!');
        Get.back();
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

import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';

import '../../../models/inbox/property/inbox_edit_form_model.dart';
import '../../../utils/toast.dart';
import '../edit_form_controller.dart';

class EditCaseStudiesController extends EditFormController {
  int caseStudiesId = 0;

  @override
  Future<void> fetchData(int id) async {
    try {
      isLoading(true);

      final response = await dio.get(
        '$baseUrl/case-studies/view-form-case-study-detail/$id',
        options: http.Options(
          headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null) {
          final formCaseStudies = InboxEditForm.fromJson(rawData);
          setInitialValue(formCaseStudies);
          caseStudiesId = id;
        }
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> deleteHistory(int? id) async {
    try {
      final accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty || id == null) {
        showErrorToast('Gagal menghapus Quotation');
      }

      final response = await dio.delete(
        '$baseUrl/case-studies/delete-history-activity/$id',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        historyList.removeWhere((history) => history.id == id);
        showSuccessToast('Berhasil menghapus History');
      } else {
        showErrorToast('Gagal menghapus History');
        // debugPrint("Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      // debugPrint('Error fetching data: $e');
      showErrorToast('Terjadi kesalahan saat menghapus data');
    }
  }

  @override
  Future<void> submitForm() async {
    for (int i = 0; i < picClients.length; i++) {
      picClients[i] = picClients[i].copyWith(
        name: picNameControllers[i].value.text,
        position: picPositionControllers[i].value.text,
      );
    }

    try {
      isLoading(true);

      final isFormValid = await validateForm();
      if (!isFormValid) {
        isLoading(false);
        return;
      }

      final data = {
        "project_tracker": "true",
        "pic": selectedPic.value?['value'],
        "status": selectedStatus.value?['value'],
        "priority": selectedPriority.value?['value'],
        "type": selectedType.map((type) => type['value']).toList(),
        "client_pic": picClients.map((picClient) => picClient.toJson()).toList(),
        "activity": createActivityList(),
        "remarks": activityRemarks.value.text,
        "notes": activityAdditionalNotes.value.text,
        "url_track_status": urlTrackingEnabled.value,
        "url": urlTrackingUrl.value,
        "password": urlTrackingPassword.value.text,
        "validity": selectedValidity.value?['value'],
      };

      final response = await dio.post(
        '$baseUrl/case-studies/save-form-case-study-detail/$caseStudiesId',
        data: data,
        options: http.Options(
          headers: {
            // 'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );

      isLoading(false);

      if (response.statusCode == 200 && response.data != null) {
        showSuccessToast('Berhasil mengubah Case Study!');
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

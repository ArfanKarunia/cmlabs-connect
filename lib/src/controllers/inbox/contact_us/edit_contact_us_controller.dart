import 'package:dio/dio.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/inbox_edit_form_model.dart';
import '../../../utils/toast.dart';
import '../edit_form_controller.dart';

class EditContactUsController extends EditFormController {
  int contactUsId = 0;

  @override
  Future<void> fetchData(int id) async {
    try {
      isLoading(true);

      final response = await dio.get(
        '$baseUrl/contact-us/view-detail-form-contact-us/$id',
        options: http.Options(
          headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null) {
          final formContactUs = InboxEditForm.fromJson(rawData);
          setInitialValue(formContactUs);
          contactUsId = id;
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
        '$baseUrl/contact-us/delete-history-activity/$id',
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

      debugPrint(data.toString());

      final response = await dio.post(
        '$baseUrl/contact-us/save-form-detail-contact-us/$contactUsId',
        data: data,
        options: http.Options(
          headers: {
            // 'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );

      debugPrint(response.toString());

      isLoading(false);

      if (response.statusCode == 200) {
        showSuccessToast('Berhasil mengubah Case Study!');
        Get.back();
      }
    } on http.DioException catch (e) {
      isLoading(false);
      final errors = e.response?.data['message'];

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

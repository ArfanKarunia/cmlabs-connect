import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/toast.dart';
import '../edit_form_controller.dart';

class EditQuotationController extends EditFormController {
  int quotationId = 0;

  @override
  Future<void> deleteHistory(int? id) async {
    try {
      final accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty || id == null) {
        showErrorToast('Gagal menghapus Quotation');
      }

      final response = await dio.delete(
        '$baseUrl/quotation/delete_history_byId/$id',
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

        // General
        "pic": selectedPic.value?['value'].toString(),
        "status": selectedStatus.value?['value'].toString(),
        "priority": selectedPriority.value?['value'].toString(),
        "type": selectedType.map((type) => type['value'].toString()).toList(),
        "client_pic": picClients.asMap().map((index, picClient) => MapEntry(index.toString(), picClient.toJson())),

        // Activity
        "meeting_topic": activityName.map((name) => name.text).toList(),
        "meeting_schedule": activitySchedule
            .map((schedule) => schedule != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule) : null)
            .toList(),
        "meeting_status": activityStatus.map((status) => status?['value'].toString()).toList(),
        "meeting_type": activityType.map((type) => type?['value']).toList(),
        "meeting_available_to_user":
            activityAvailableToUser.map((availableToUser) => availableToUser ? "1" : "0").toList(),
        "meeting_note": activityNote.map((note) => note.text).toList(),
        "remarks": activityRemarks.value.text,
        "notes": activityAdditionalNotes.value.text,

        // URL Tracking
        "url_track_status": urlTrackingEnabled.value,
        "url": urlTrackingUrl.value,
        "password": urlTrackingPassword.value.text,
        "validity": selectedValidity.value?['value'],
      };

      print(quotationId);
      print(data);

      final response = await dio.put(
        '$baseUrl/quotation/update/$quotationId',
        data: data,
        options: http.Options(
          headers: {
            // 'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );

      isLoading(false);

      if (response.statusCode == 200) {
        showSuccessToast('Berhasil mengubah Quotation!');
        Get.back();
      }
    } on http.DioException catch (e) {
      isLoading(false);
      final errors = e.response?.data['message'];
      print(e.response?.statusCode);
      print(errors);

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

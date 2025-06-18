import 'dart:io';

import 'package:dio/dio.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/config.dart';
import '../../models/inbox/property/project_history_model.dart';
import '../user/user_controller.dart';

class EditHistoryController extends GetxController {
  Rx<TextEditingController> activityName = TextEditingController().obs;
  RxList<Map<String, String>> activityTypeList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> activityType = <Map<String, String>>[].obs;
  Rx<TextEditingController> activityNote = TextEditingController().obs;
  Rx<DateTime?> activityCreatedAt = Rx<DateTime?>(null);
  Rx<bool> availableToUser = false.obs;

  // Error Text
  Rx<String?> activityNameError = Rx<String?>(null);
  Rx<String?> activityFileError = Rx<String?>(null);

  Rx<bool> isLoading = false.obs;

  final userController = Get.find<UserController>();
  final dio = http.Dio();
  final baseUrl = Config.baseURL;

  @override
  void onReady() {
    fetchActivityType();
  }

  @override
  void dispose() {
    activityName.value.dispose();
    activityNote.value.dispose();
    super.dispose();
  }

  void setInitialValue(ProjectHistory history) {
    activityName.value.text = history.name ?? '';
    if (history.type != null) {
      for (final type in history.type!) {
        activityType.add({'value': type, 'label': type});
      }
    }
    activityNote.value.text = history.note ?? '';
    availableToUser.value = history.availableToUser ?? false;
    activityCreatedAt.value = history.createdAt;
  }

  Future<void> fetchActivityType() async {
    final response = await dio.get(
      '$baseUrl/quotation/fetch/get-data-type-activity',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final List<String> types = List<String>.from(response.data['data'] ?? []);
      final List<Map<String, String>> mapTypes = types.map((type) {
        return {
          'value': type,
          'label': type,
        };
      }).toList();
      activityTypeList.assignAll(mapTypes);
    }
  }

  Future<bool> validateForm(File? file) async {
    activityNameError.value = activityName.value.text.isEmpty ? 'The activity name must not be empty.' : null;
    if (file != null) {
      final fileSize = await file.length();
      activityFileError.value = fileSize > 2 * 1024 * 1024 ? 'The maximum of file size is 2 MB !' : null;
    }

    return activityNameError.value == null && activityFileError.value == null;
  }

  List<Map<String, String>> getList(String data) {
    switch (data) {
      case 'historyType':
        return activityTypeList;
      default:
        return [];
    }
  }

  void setValue({
    required String data,
    required dynamic value,
  }) {
    switch (data) {
      case 'historyType':
        activityType.value = value;
        break;
      default:
        break;
    }
  }

  Future<void> submitHistory({required int id, File? file}) async {}
}

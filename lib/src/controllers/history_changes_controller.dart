import 'dart:convert';
import 'dart:io';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/models/history_changes_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPkg;
import 'package:get/get.dart';

import '../utils/toast.dart';

class HistoryChangesController extends GetxController {
  var search = Rx<String?>(null);

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  var historyList = Rx<List<HistoryChangesModel?>>([]);
  var typeHistoryList = Rx<List<Map<String, String>?>>([]);

  var nameActivity = Rx<String?>(null);
  var status = Rx<int?>(null);
  var type = Rx<List<String?>>([]);
  var note = Rx<String?>(null);
  var availableToUser = Rx<String?>(null);
  var createdAt = Rx<String?>(null);
  var file = Rx<File?>(null);

  Future<void> updateHistory(int idHistory) async {
  try {
    String? accessToken = authenticationController.accesToken.value;

    // Prepare the FormData
    dioPkg.FormData formData = dioPkg.FormData.fromMap({
      "id": idHistory,
      "name": nameActivity.value ?? "",
      "status": status.value?.toString() ?? "0",
      "type": type.value, // Make sure this is a List<String>
      "note": note.value ?? "",
      "available_to_user": availableToUser.value ?? "on",
      "created_at": createdAt.value ?? "",
      // Handle file upload if a file is provided
      "file": file.value != null
          ? await dioPkg.MultipartFile.fromFile(file.value!.path)
          : null,
    });

    print(idHistory);

    print(formData);

    // // Make the POST request
    // final response = await dio.put(
    //   '$baseUrl/quotation/update_history_byId',
    //   options: Options(
    //     headers: {'Authorization': 'Bearer $accessToken'},
    //     contentType: 'multipart/form-data',
    //   ),
    //   data: formData,
    // );

    // // Handle the response
    // if (response.statusCode == 200 && response.data != null) {
    //   showSuccessToast("Success: update history");
    //   Get.back();
    // } else {
    //   showErrorToast("Failed: update history");
    // }
  } catch (e) {
    print('Error fetching status data: $e');
  }
}


  Future<void> fetchHistoryChanges(int idQuotation) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/quotation/get_history',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "id": idQuotation,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        historyList.value = responseData.map<HistoryChangesModel>((item) {
          return HistoryChangesModel.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> fetchTypeHistory(int idHistory) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/quotation/get_history_byId',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "id": idHistory,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data']['data'];

        var typeList = (responseData['types'] as List<dynamic>)
            .map((item) => {
                  'value': item?.toString() ?? '',
                  'label': item?.toString() ?? '',
                })
            .toList();

        typeHistoryList.value = typeList;
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    result = typeHistoryList.value;

    // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
    if (search.value != null && search.value!.isNotEmpty) {
      final query = search.value!.toLowerCase();
      result = result.where((type) {
        return type['value'].toLowerCase().contains(query) ||
            type['label'].toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }
}

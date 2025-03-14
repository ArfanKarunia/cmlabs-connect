import 'dart:io';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:cmlabs_connect/src/models/history_changes_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPkg;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/toast.dart';

class HistoryChangesController extends GetxController {
  var search = Rx<String?>(null);

  final UserController userController = Get.put(UserController());

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  var historyList = Rx<List<HistoryChangesModel?>>([]);
  var typeHistoryList = Rx<List<Map<String, String>?>>([]);

  var nameActivity = Rx<String?>(null);
  var status = Rx<int?>(null);
  var type = Rx<List<String?>>([]);
  var note = Rx<String?>(null);
  var availableToUser = Rx<int?>(null);
  var createdAt = Rx<String?>(null);
  var file = Rx<File?>(null);

  Future<void> updateHistory(int idHistory) async {
    try {
      // Mengatur FormData

      String? formattedDate;
      if (createdAt.value != null) {
        try {
          // Format input tanggal awal (jika sesuai format `19/11/2024 09:02 AM`)
          DateFormat inputFormat = DateFormat('dd/MM/yyyy hh:mm a');
          DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

          // Parsing input dan format ulang
          DateTime parsedDate = inputFormat.parse(createdAt.value!);
          formattedDate = outputFormat.format(parsedDate);
        } catch (e) {
          print('Error formatting date: $e');
        }
      }

      final Map<String, dynamic> typeFields = {};
      for (int i = 0; i < type.value.length; i++) {
        typeFields['type[$i]'] = type.value[i];
      }

      dioPkg.FormData formData = dioPkg.FormData.fromMap({
        "id": idHistory,
        "name": nameActivity.value ?? "",
        "status": status.value?.toString() ?? "0", // Status sebagai String
        "note": note.value ?? "",
        "available_to_user": availableToUser.value ?? 0,
        "created_at": formattedDate ?? '',
        "file": file.value != null ? await dioPkg.MultipartFile.fromFile(file.value!.path) : null,
        ...typeFields, // Tambahkan field dinamis untuk `type`
      });

      var data = {
        "id": idHistory,
        "name": nameActivity.value ?? "",
        "status": status.value?.toString() ?? "0", // Status sebagai String
        "note": note.value ?? "",
        "available_to_user": availableToUser.value ?? 0,
        "created_at": formattedDate ?? '',
        "file": file.value != null ? await dioPkg.MultipartFile.fromFile(file.value!.path) : null,
        ...typeFields, // Tambahkan field dinamis untuk `type`
      };
      print(data);

      // Set headers untuk dio request
      dio.options.headers = {
        'Authorization': 'Bearer ${userController.accesToken.value}',
        'Content-Type': 'multipart/form-data',
      };

      // Kirim request PUT ke server
      final response = await dio.post(
        '$baseUrl/quotation/update_history_byId',
        data: formData,
      );

      if (response.statusCode == 200) {
        // Menampilkan Toast/Sukses ketika berhasil
        print("Success: update history");
        showSuccessToast("Success: update history");

        Get.back(); // Menutup halaman sebelumnya
      } else {
        // Menampilkan pesan error jika gagal
        String errorMessage = "Failed to update history";
        if (response.data != null) {
          errorMessage = response.data["message"] ?? errorMessage;
        }
        showErrorToast("Failed: update history");
        print('Error: $errorMessage');
      }
    } catch (e) {
      // Menangani exception
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteHistory(int idHistory) async {
    try {
      String? accessToken = userController.accesToken.value;

      // untuk Filter Status
      final response = await dio.delete('$baseUrl/quotation/delete_history_byId',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {"id": idHistory});

      if (response.statusCode == 200 && response.data != null) {
        showSuccessToast("Success: Delete History");
      } else {
        showErrorToast("Failed: Delete History");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> fetchHistoryChanges(int idQuotation) async {
    try {
      String? accessToken = userController.accesToken.value;

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
      String? accessToken = userController.accesToken.value;

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
        return type['value'].toLowerCase().contains(query) || type['label'].toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }
}

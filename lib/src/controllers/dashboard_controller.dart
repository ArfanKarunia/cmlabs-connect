import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constant/config.dart';
import '../models/dashboard_data_model.dart';

class DashboardController extends GetxController {
  // var dashboardData = Rx<DashboardData?>(null);

  var amount_newLeads = Rx<int>(0);
  var amount_acceptedLeads = Rx<int>(0);
  var amount_followedUpLeads = Rx<int>(0);
  var amount_last30Day = Rx<int>(0);

  var filterCategory = <String>[].obs;
  var filterClientSource = <String>[].obs;
  var filterPic = <String>[].obs;
  var filterStartDate = Rx<DateTime?>(null);
  var filterEndDate = Rx<DateTime?>(null);

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final UserControler userControler = Get.put(UserControler());

  Box<DashboardData>? dashboardBox;

  final dio = Dio();
  final baseUrl = Config.baseURL;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Membuka box untuk menyimpan data dashboard
    dashboardBox = await Hive.openBox<DashboardData>('dashboardBox');
    saveDashboardData();
  }

  @override
  void dispose() {
    dashboardBox?.close();
    super.dispose();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> saveDashboardData() async {
    try {
      // Ambil data yang diperlukan dari response
      amount_acceptedLeads.value = await fetchAcceptedLeadData();
      amount_newLeads.value = await fetchNewLeadData();
      amount_followedUpLeads.value = await fetchFollowedUpLeadData();
      amount_last30Day.value = await fetchLast30DaysLeadData();

      // dashboardData.value = DashboardData(
      //   amountAcceptedLeads: amount_acceptedLeads.value,
      //   amountNewLeads: amount_newLeads.value,
      //   amountFollowedupLeads: amount_followedUpLeads.value,
      //   amountLast30Days: amount_last30Day.value,
      // );


      // await dashboardBox!.put('dashboard', dashboardData.value!);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void clearFilter() {
    filterPic.clear();
    filterCategory.clear();
    filterClientSource.clear();

    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  Future<int> fetchNewLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = userControler.accesToken.value;

      String? startDateString = filterStartDate.value != null
          ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
          : null;
      String? endDateString = filterEndDate.value != null
          ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
          : null;

      // Construct query parameters
      Map<String, String> queryParams = {};

      if (startDateString != null) {
        queryParams['startDate'] = startDateString;
      }
      if (endDateString != null) {
        queryParams['endDate'] = endDateString;
      }
      if (filterCategory.isNotEmpty) {
        queryParams['category'] = filterCategory.join(',');
      }
      if (filterPic.isNotEmpty) {
        queryParams['pic'] = filterPic.join(',');
      }
      if (filterClientSource.isNotEmpty) {
        queryParams['clientSource'] = filterClientSource.join(',');
      }

      // Build the query string
      String queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      // Construct the full URL
      String url = '$baseUrl/dashboard/total_today';
      if (queryString.isNotEmpty) {
        url += '?$queryString';
      }

      // Ambil data dari API
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        if (responseData['status'] == 'success') {
          // Kembalikan data yang di didapatkan dari API
          return responseData['data'] ?? 0;
        } else {
          print("Status API tidak 'success'.");
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return 0;
  }

  Future<int> fetchLast30DaysLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = userControler.accesToken.value;

      String? startDateString = filterStartDate.value != null
          ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
          : null;
      String? endDateString = filterEndDate.value != null
          ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
          : null;

      // Construct query parameters
      Map<String, String> queryParams = {};

      if (startDateString != null) {
        queryParams['startDate'] = startDateString;
      }
      if (endDateString != null) {
        queryParams['endDate'] = endDateString;
      }
      if (filterCategory.isNotEmpty) {
        queryParams['category'] = filterCategory.join(',');
      }
      if (filterPic.isNotEmpty) {
        queryParams['pic'] = filterPic.join(',');
      }
      if (filterClientSource.isNotEmpty) {
        queryParams['clientSource'] = filterClientSource.join(',');
      }

      // Build the query string
      String queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      // Construct the full URL
      String url = '$baseUrl/dashboard/total_30_today';
      if (queryString.isNotEmpty) {
        url += '?$queryString';
      }

      // Ambil data dari API
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        if (responseData['status'] == 'success') {
          // Kembalikan data yang di didapatkan dari API
          return responseData['data'] ?? 0;
        } else {
          print("Status API tidak 'success'.");
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return 0;
  }

  Future<int> fetchFollowedUpLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = userControler.accesToken.value;

      String? startDateString = filterStartDate.value != null
          ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
          : null;
      String? endDateString = filterEndDate.value != null
          ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
          : null;

      // Construct query parameters
      Map<String, String> queryParams = {};

      if (startDateString != null) {
        queryParams['startDate'] = startDateString;
      }
      if (endDateString != null) {
        queryParams['endDate'] = endDateString;
      }
      if (filterCategory.isNotEmpty) {
        queryParams['category'] = filterCategory.join(',');
      }
      if (filterPic.isNotEmpty) {
        queryParams['pic'] = filterPic.join(',');
      }
      if (filterClientSource.isNotEmpty) {
        queryParams['clientSource'] = filterClientSource.join(',');
      }

      // Build the query string
      String queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      // Construct the full URL
      String url = '$baseUrl/dashboard/total_followed_up';
      if (queryString.isNotEmpty) {
        url += '?$queryString';
      }

      // Ambil data dari API
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        if (responseData['status'] == 'success') {
          // Kembalikan data yang di didapatkan dari API
          return responseData['data'] ?? 0;
        } else {
          print("Status API tidak 'success'.");
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return 0;
  }

  Future<int> fetchAcceptedLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = userControler.accesToken.value;

      String? startDateString = filterStartDate.value != null
          ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
          : null;
      String? endDateString = filterEndDate.value != null
          ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
          : null;

      // Construct query parameters
      Map<String, String> queryParams = {};

      if (startDateString != null) {
        queryParams['startDate'] = startDateString;
      }
      if (endDateString != null) {
        queryParams['endDate'] = endDateString;
      }
      if (filterCategory.isNotEmpty) {
        queryParams['category'] = filterCategory.join(',');
      }
      if (filterPic.isNotEmpty) {
        queryParams['pic'] = filterPic.join(',');
      }
      if (filterClientSource.isNotEmpty) {
        queryParams['clientSource'] = filterClientSource.join(',');
      }

      // Build the query string
      String queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      // Construct the full URL
      String url = '$baseUrl/dashboard/total_accepted';
      if (queryString.isNotEmpty) {
        url += '?$queryString';
      }

      // Ambil data dari API
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        if (responseData['status'] == 'success') {
          return responseData['data'] ?? 0;
        } else {
          print("Status API tidak 'success'.");
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return 0;
  }

  void clearFilterClientSource() {
    filterClientSource.clear();
  }

  void clearFilterPic() {
    filterPic.clear();
  }

  void clearFilterCategory() {
    filterCategory.clear();
  }

  void clearDataRange() {
    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  /*
  
    FUNGSI Set Filter Category

    Fungsi ini digunakan untuk menyimpan data inputan filter Category

  */
  void addFilterCategory(String category) {
    filterCategory.add(category);
  }

  void removeFilterCategory(String category) {
    filterCategory.remove(category);
  }

  /*
  
    FUNGSI Set Filter Client Source

    Fungsi ini digunakan untuk menyimpan data inputan filter Client Source

  */
  void addFilterClientSource(String clientSource) {
    filterClientSource.add(clientSource);
  }

  void removeClientSource(String clientSource) {
    filterClientSource.remove(clientSource);
  }

  /*
  
    FUNGSI Set Filter PIC

    Fungsi ini digunakan untuk menyimpan data inputan filter PIC

  */
  void addFilterPic(String pic) {
    filterPic.add(pic);
  }

  void removeFilterPic(String pic) {
    filterPic.remove(pic);
  }

  // Fungsi untuk menyimpan data ke dalam Hive
  // Future<void> saveDashboardData(DashboardData data) async {
  //   if (dashboardBox != null) {
  //     await dashboardBox!.put('dashboard', data);
  //     print("Data dashboard disimpan: $data");
  //   } else {
  //     print("Dashboard box belum diinisialisasi.");
  //   }
  // }

  // Fungsi untuk mendapatkan data dari Hive
  DashboardData? getDashboardDataFromHive() {
    return dashboardBox?.get('dashboard');
  }
}

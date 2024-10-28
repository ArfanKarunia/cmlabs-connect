import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constant/config.dart';
import '../models/dashboard_data_model.dart';

class DashboardController extends GetxController {
  var dashboardData = Rx<DashboardData?>(null);

  var amount_newLeads = Rx<int>(0);
  var amount_acceptedLeads = Rx<int>(0);
  var amount_followedUpLeads = Rx<int>(0);
  var amount_last30Day = Rx<int>(0);

  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

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
  void saveDashboardData() async {
    try {
      // Ambil data yang diperlukan dari response
      amount_acceptedLeads.value = await fetchAcceptedLeadData();
      amount_newLeads.value = await fetchNewLeadData();
      amount_followedUpLeads.value = await fetchFollowedUpLeadData();
      amount_last30Day.value = await fetchLast30DaysLeadData();

      dashboardData.value = DashboardData(
        amountAcceptedLeads: amount_acceptedLeads.value,
        amountNewLeads: amount_newLeads.value,
        amountFollowedupLeads: amount_followedUpLeads.value,
        amountLast30Days: amount_last30Day.value,
      );

      await dashboardBox!.put('dashboard', dashboardData.value!);

    } catch (e) {

      print('Error fetching data: $e');
    }
  }

  Future<int> fetchNewLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        baseUrl + '/dashboard/total_today',
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
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        baseUrl + '/dashboard/total_30_today',
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
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        baseUrl + '/dashboard/total_followed_up',
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
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        baseUrl + '/dashboard/total_accepted',
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

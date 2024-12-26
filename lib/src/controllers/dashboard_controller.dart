import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constant/config.dart';
import '../utils/string_utils.dart';

class DashboardController extends GetxController {
  // var dashboardData = Rx<DashboardData?>(null);

  var amount_newLeads = Rx<int>(0);
  var amount_acceptedLeads = Rx<int>(0);
  var amount_followedUpLeads = Rx<int>(0);
  var amount_last30Day = Rx<int>(0);

  var filterCategory = <String>[].obs;
  var filterClientSource = Rx<String?>(null);
  var filterPic = Rx<String?>(null);
  var filterStartDate = Rx<DateTime?>(null);
  var filterEndDate = Rx<DateTime?>(null);

  final UserControler userControler = Get.put(UserControler());

  final dio = Dio();
  final baseUrl = Config.baseURL;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Membuka box untuk menyimpan data dashboard
    saveDashboardData();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> saveDashboardData() async {
    try {
      // Ambil data yang diperlukan dari response
      amount_acceptedLeads.value = await fetchAcceptedLeadData();
      amount_newLeads.value = await fetchNewLeadData();
      amount_followedUpLeads.value = await fetchFollowedUpLeadData();
      amount_last30Day.value = await fetchLast30DaysLeadData();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void clearFilter() {
    filterPic.value = null;
    filterCategory.clear();
    filterClientSource.value == null;

    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  Future<int> fetchNewLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = userControler.accesToken.value;

      // String? startDateString = filterStartDate.value != null
      //     ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
      //     : null;
      // String? endDateString = filterEndDate.value != null
      //     ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
      //     : null;

      // // Construct query parameters
      // Map<String, String> queryParams = {};

      // if (startDateString != null) {
      //   queryParams['startDate'] = startDateString;
      // }
      // if (endDateString != null) {
      //   queryParams['endDate'] = endDateString;
      // }
      // if (filterCategory.isNotEmpty) {
      //   queryParams['category'] = filterCategory.join(',');
      // }
      // if (filterPic.value != null) {
      //   queryParams['pic'] = filterPic.value!;
      // }
      // if (filterClientSource.value != null) {
      //   queryParams['clientSource'] = filterClientSource.value!;
      // }

      // // Build the query string
      // String queryString = queryParams.entries
      //     .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
      //     .join('&');

      // // Construct the full URL
      // String url = '$baseUrl/dashboard/total_today';
      // if (queryString.isNotEmpty) {
      //   url += '?$queryString';
      // }

      String url = constructDashboardUrl('total_today');


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


      String url = constructDashboardUrl('total_30_today');


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

      // String? startDateString = filterStartDate.value != null
      //     ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
      //     : null;
      // String? endDateString = filterEndDate.value != null
      //     ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
      //     : null;

      // // Construct query parameters
      // Map<String, String> queryParams = {};

      // if (startDateString != null) {
      //   queryParams['startDate'] = startDateString;
      // }
      // if (endDateString != null) {
      //   queryParams['endDate'] = endDateString;
      // }
      // if (filterCategory.isNotEmpty) {
      //   queryParams['category'] = filterCategory.join(',');
      // }
      // if (filterPic.value != null) {
      //   queryParams['pic'] = filterPic.value!;
      // }
      // if (filterClientSource.value != null) {
      //   queryParams['clientSource'] = filterClientSource.value!;
      // }

      // // Build the query string
      // String queryString = queryParams.entries
      //     .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
      //     .join('&');


      // // Construct the full URL
      // String url = '$baseUrl/dashboard/total_followed_up';
      // if (queryString.isNotEmpty) {
      //   url += '?$queryString';
      // }
      String url = constructDashboardUrl('total_followed_up');

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

      String url = constructDashboardUrl("total_accepted");

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
    filterClientSource.value = null;
  }

  void clearFilterPic() {
    filterPic.value = null;
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
    filterClientSource.value = clientSource;
  }

  void removeClientSource() {
    filterClientSource.value = null;
  }

  /*
  
    FUNGSI Set Filter PIC

    Fungsi ini digunakan untuk menyimpan data inputan filter PIC

  */
  void addFilterPic(String pic) {
    filterPic.value = pic;
  }

  void removeFilterPic() {
    filterPic.value = null;
  }

  String constructDashboardUrl(String metric)  {
    // Konversi filter tanggal ke format string
    String? startDateString = filterStartDate.value != null
        ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
        : null;
    String? endDateString = filterEndDate.value != null
        ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
        : null;

    // Construct query parameters
    List<String> queryParams = [];

    if (startDateString != null) {
      queryParams.add('startDate=${Uri.encodeComponent(startDateString)}');
    }
    if (endDateString != null) {
      queryParams.add('endDate=${Uri.encodeComponent(endDateString)}');
    }
    if (filterPic.value != null) {
      queryParams.add(
          'pic=${Uri.encodeComponent(StringUtils.toCamelCase(filterPic.value))}');
    }
    if (filterClientSource.value != null) {
      queryParams.add(
          'clientSource=${Uri.encodeComponent(StringUtils.toCamelCase(filterClientSource.value))}');
    }

    // Handle category filter with array format
    if (filterCategory.isNotEmpty) {
      queryParams.addAll(filterCategory
          .map((category) => 'category[]=${Uri.encodeComponent(category)}'));
    }

    // Combine all query parameters
    String queryString = queryParams.join('&');
    print('category: ${filterCategory}');
    print('Constructed URL: $queryString');

    // Construct the full URL
    String url = '$baseUrl/dashboard/$metric?';
    if (queryString.isNotEmpty) {
      url += '&$queryString';
    }

    // Debug log

    return url;
  }
}

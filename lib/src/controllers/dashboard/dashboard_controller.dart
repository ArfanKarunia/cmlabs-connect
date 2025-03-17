import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/config.dart';
import '../../utils/string_utils.dart';

class DashboardController extends GetxController {
  Rx<int> newLeads = Rx<int>(0);
  Rx<int> last30Day = Rx<int>(0);
  Rx<int> acceptedLeads = Rx<int>(0);
  Rx<int> followedUpLeads = Rx<int>(0);

  RxList<String> filterCategory = <String>[].obs;
  Rx<String?> filterClientSource = Rx<String?>(null);
  Rx<String?> filterPic = Rx<String?>(null);
  Rx<DateTime?> filterStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);

  final UserController userController = Get.find<UserController>();

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      newLeads.value = await fetchData('total_today');
      last30Day.value = await fetchData('total_30_today');
      acceptedLeads.value = await fetchData('total_accepted');
      followedUpLeads.value = await fetchData('total_followed_up');
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<int> fetchData(String metric) async {
    try {
      String? accessToken = userController.accesToken.value;

      String url = constructDashboardUrl(metric);

      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        if (responseData['status'] == 'success') return responseData['data'] ?? 0;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
    return 0;
  }

  void addFilterCategory(String category) {
    filterCategory.add(category);
  }

  void removeFilterCategory(String category) {
    filterCategory.remove(category);
  }

  void clearFilterCategory() {
    filterCategory.clear();
  }

  void addFilterClientSource(String clientSource) {
    filterClientSource.value = clientSource;
  }

  void clearFilterClientSource() {
    filterClientSource.value = null;
  }

  void addFilterPic(String pic) {
    filterPic.value = pic;
  }

  void clearFilterPic() {
    filterPic.value = null;
  }

  void addFilterDate({DateTime? start, DateTime? end}) {
    filterStartDate.value = start ?? filterStartDate.value;
    filterEndDate.value = end ?? filterEndDate.value;
  }

  void clearFilterDate() {
    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  void clearAll() {
    clearFilterCategory();
    clearFilterClientSource();
    clearFilterPic();
    clearFilterDate();
  }

  String constructDashboardUrl(String metric) {
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
      queryParams.add('pic=${Uri.encodeComponent(StringUtils.toCamelCase(filterPic.value))}');
    }
    if (filterClientSource.value != null) {
      queryParams.add('clientSource=${Uri.encodeComponent(StringUtils.toCamelCase(filterClientSource.value))}');
    }

    // Handle category filter with array format
    if (filterCategory.isNotEmpty) {
      queryParams.addAll(filterCategory.map((category) => 'category[]=${Uri.encodeComponent(category)}'));
    }

    // Combine all query parameters
    String queryString = queryParams.join('&');

    // Construct the full URL
    String url = '$baseUrl/dashboard/$metric?';
    if (queryString.isNotEmpty) {
      url += '&$queryString';
    }

    // Debug log

    return url;
  }
}

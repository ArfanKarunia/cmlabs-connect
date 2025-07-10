import 'package:cmlabs_connect/src/controllers/dashboard/dashboard_controller.dart';
import 'package:cmlabs_connect/src/controllers/inbox/quotation/quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../constant/config.dart';
import '../../routes.dart';
import '../inbox/case_studies/case_studies_controller.dart';
import '../inbox/contact_us/contact_us_controller.dart';
import '../inbox/faq/faq_controller.dart';
import '../inbox/inbox_controller.dart';

enum InboxFilterType {
  year,
  month,
  days,
  timeRange,
  clientSource,
  pic,
  category,
}

class FilterController extends GetxController {
  // Fetched Filter List
  RxList<Map<String, String>> categoryList = <Map<String, String>>[
    {'value': 'all', 'label': 'All'},
  ].obs;
  RxList<Map<String, String>> picList = <Map<String, String>>[
    {'value': 'all', 'label': 'All'},
  ].obs;
  RxList<Map<String, String>> clientSourceList = <Map<String, String>>[
    {'value': 'all', 'label': 'All'},
  ].obs;

  // Choosed Filter List
  Rx<String> search = ''.obs;
  RxList<Map<String, String>> filterCategoryList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> filterPic = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> filterClientSource = Rx<Map<String, String>?>(null);

  // Date Filter
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  bool get isFilterApplied =>
      filterClientSource.value != null ||
      filterPic.value != null ||
      filterCategoryList.isNotEmpty ||
      startDate.value != null ||
      endDate.value != null;

  // Error message variables
  Rx<String?> startDateError = null.obs;
  Rx<String?> endDateError = null.obs;
  void validateDateFields() {
    if (startDate.value == null && endDate.value != null) {
      startDateError.value = 'Start date must be filled';
    }
  }

  // Loading
  Rx<bool> isLoading = false.obs;

  final Dio dio = Dio();
  final List<InboxController> inboxController = [
    Get.find<QuotationController>(),
    Get.find<CaseStudiesController>(),
    Get.find<ContactUsController>(),
    Get.find<FaqController>(),
  ];
  final DashboardController dashboardController = Get.find<DashboardController>();
  final UserController userController = Get.find<UserController>();

  final String baseUrl = Config.baseURL;

  @override
  void onReady() {
    super.onReady();
    fetchClientSourceFilter();
    fetchPicFilter();
    fetchCategoryFilter();
  }

  Future<void> fetchFilter(InboxFilterType filter) async {
    try {
      switch (filter) {
        case InboxFilterType.clientSource:
          await fetchClientSourceFilter();
          break;
        case InboxFilterType.pic:
          await fetchPicFilter();
          break;
        case InboxFilterType.category:
          await fetchCategoryFilter();
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> fetchClientSourceFilter() async {
    final response = await dio.get(
      '$baseUrl/filter/client_source',
      options: Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'].map<Map<String, String>>((clientSource) {
        return {
          'value': clientSource['value']?.toString() ?? '',
          'label': clientSource['label']?.toString() ?? '',
        };
      }).toList();

      clientSourceList.assignAll(data);
    }
  }

  Future<void> fetchPicFilter() async {
    final response = await dio.get(
      '$baseUrl/filter/pic',
      options: Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'].map<Map<String, String>>((pic) {
        return {
          'value': pic['value']?.toString() ?? '',
          'label': pic['label']?.toString() ?? '',
        };
      }).toList();

      picList.addAll(data);
    }
  }

  Future<void> fetchCategoryFilter() async {
    final response = await dio.get(
      '$baseUrl/filter/data_services',
      options: Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'].map<Map<String, String>>((category) {
        return {
          'value': category['id']?.toString() ?? '',
          'label': category['text']?.toString() ?? '',
        };
      }).toList();

      categoryList.addAll(data);
    }
  }

  void addFilterClientSource(Map<String, String>? clientSource) {
    if (clientSource == null) return;

    if (clientSource['value'] == "all") {
      clearFilterClientSource();
    } else {
      filterClientSource.value = clientSource;
    }
  }

  void clearFilterClientSource() {
    filterClientSource.value = null;
  }

  void addFilterPic(Map<String, String>? pic) {
    if (pic == null) return;

    if (pic['value'] == "all") {
      clearFilterPic();
    } else {
      filterPic.value = pic;
    }
  }

  void clearFilterPic() {
    filterPic.value = null;
  }

  void addFilterCategory(Map<String, String>? category) {
    if (category == null) return;

    if (category['value'] == "all") {
      clearFilterCategory();
    } else {
      if (filterCategoryList.any((element) => element['value'] == "all")) {
        filterCategoryList.removeWhere((element) => element['value'] == "all");
      }

      if (!filterCategoryList.contains(category)) {
        filterCategoryList.add(category);
      }
    }
  }

  void deleteFilterCategory(Map<String, String> category) {
    filterCategoryList.remove(category);
  }

  void clearFilterCategory() {
    filterCategoryList.clear();
  }

  void setSearch(String query) {
    search.value = query;
  }

  void clearSearch() {
    search.value = '';
  }

  void clearAll() {
    setDateRange(null, null);
    clearFilterCategory();
    clearFilterClientSource();
    clearFilterPic();
    clearSearch();
  }

  List<Map<String, String>> searchData(InboxFilterType filter) {
    switch (filter) {
      case InboxFilterType.clientSource:
        return clientSourceList
            .where((element) => element['label']?.toLowerCase().contains(search.value.toLowerCase()) ?? false)
            .toList();
      case InboxFilterType.pic:
        return picList
            .where((element) => element['label']?.toLowerCase().contains(search.value.toLowerCase()) ?? false)
            .toList();
      case InboxFilterType.category:
        return categoryList
            .where((element) => element['label']?.toLowerCase().contains(search.value.toLowerCase()) ?? false)
            .toList();
      default:
        return [];
    }
  }

  void filterByClientSource() {
    if (filterClientSource.value != null) {
      for (InboxController controller in inboxController) {
        controller.clearFilterClientSource();
        controller.addFilterClientSource(filterClientSource.value!['value'].toString());
      }
      dashboardController.clearFilterClientSource();
      dashboardController.addFilterClientSource(filterClientSource.value!['value'].toString());
    }
  }

  void filterByPic() {
    if (filterPic.value != null) {
      for (InboxController controller in inboxController) {
        controller.clearFilterPic();
        controller.addFilterPic(filterPic.value!['value'].toString());
      }
      dashboardController.clearFilterPic();
      dashboardController.addFilterPic(filterPic.value!['value'].toString());
    }
  }

  void filterByCategory() {
    for (InboxController controller in inboxController) {
      controller.clearFilterCategory();
      for (Map<String, String> category in filterCategoryList) {
        controller.addFilterCategory(category['value'].toString());
      }
    }
    dashboardController.clearFilterCategory();
    for (Map<String, String> category in filterCategoryList) {
      dashboardController.addFilterCategory(category['value'].toString());
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    if (start != null && end == null) {
      end = DateTime.now();
    }
    startDate.value = start;
    endDate.value = end;
  }

  void filterByDateRange() {
    for (InboxController controller in inboxController) {
      controller.clearFilterDate();
      controller.addFilterDate(start: startDate.value, end: endDate.value);
    }
    dashboardController.clearFilterDate();
    dashboardController.addFilterDate(start: startDate.value, end: endDate.value);
  }

  Future<void> applyFilter() async {
    if (isLoading.isTrue) return;

    isLoading(true);

    validateDateFields();
    if (startDateError.value != null || endDateError.value != null) return;

    filterByClientSource();
    filterByPic();
    filterByCategory();
    filterByDateRange();
    for (InboxController controller in inboxController) {
      await controller.fetchList();
    }
    dashboardController.fetchDashboardData();

    isLoading(false);

    Get.until((route) => Get.currentRoute == AppRoutes.home);
  }

  Future<void> clearFilter() async {
    if (isLoading.isTrue) return;

    isLoading(true);

    clearAll();
    for (InboxController controller in inboxController) {
      controller.clearAll();
      await controller.fetchList();
    }
    dashboardController.clearAll();
    dashboardController.fetchDashboardData();

    isLoading(false);

    Get.until((route) => Get.currentRoute == AppRoutes.home);
  }
}

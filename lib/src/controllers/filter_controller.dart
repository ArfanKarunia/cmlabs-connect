import 'package:cmlabs_connect/src/controllers/dashboard_controller.dart';
import 'package:cmlabs_connect/src/controllers/inbox/quotation/quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../constant/config.dart';
import '../constant/const.dart';
import '../routes.dart';

class FilterController extends GetxController {
  // Fetched Filter List
  RxList<Map<String, String>> statusList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> clientSourceList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> picList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> categoryList = <Map<String, String>>[].obs;

  // Choosed Filter List
  Rx<String?> search = Rx<String?>(null);
  RxList<Map<String, String>> filterStatusList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> filterClientSource = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> filterPic = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> filterCategoryList = <Map<String, String>>[].obs;

  // Date Filter
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final Dio dio = Dio();
  final QuotationController quotationController = Get.put(QuotationController());
  final DashboardController dashboardController = Get.put(DashboardController());
  final UserControler userControler = Get.put(UserControler());

  final String baseUrl = Config.baseURL;

  Future<void> fetchFilter(String filter) async {
    try {
      switch (filter.toLowerCase()) {
        case 'status':
          await fetchStatusFilter();
          break;
        case 'client_source':
          await fetchClientSourceFilter();
          break;
        case 'pic':
          await fetchPicFilter();
          break;
        case 'category':
          await fetchCategoryFilter();
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> fetchStatusFilter() async {
    final response = await dio.get(
      '$baseUrl/filter/status',
      options: Options(
        headers: {'Authorization': 'Bearer ${userControler.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'].map<Map<String, String>>((status) {
        return {
          'value': status['value']?.toString() ?? '',
          'label': status['label']?.toString() ?? '',
        };
      }).toList();

      statusList.assignAll(data);
    }
  }

  Future<void> fetchClientSourceFilter() async {
    final response = await dio.get(
      '$baseUrl/filter/client_source',
      options: Options(
        headers: {'Authorization': 'Bearer ${userControler.accesToken.value}'},
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
        headers: {'Authorization': 'Bearer ${userControler.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'].map<Map<String, String>>((pic) {
        return {
          'value': pic['value']?.toString() ?? '',
          'label': pic['label']?.toString() ?? '',
        };
      }).toList();

      picList.clear();

      picList.add({'value': 'all', 'label': 'All'});
      picList.addAll(data);
    }
  }

  Future<void> fetchCategoryFilter() async {
    final response = await dio.get(
      '$baseUrl/filter/data_services',
      options: Options(
        headers: {'Authorization': 'Bearer ${userControler.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'].map<Map<String, String>>((category) {
        return {
          'value': category['id']?.toString() ?? '',
          'label': category['text']?.toString() ?? '',
        };
      }).toList();

      categoryList.clear();

      categoryList.add({'value': 'all', 'label': 'All'});
      categoryList.addAll(data);
    }
  }

  // ADD, DELETE, CLEAR Filter Status
  void addFilterStatus(Map<String, String> status) {
    // Cek jika status yang dipilih adalah "all"
    if (status['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearFilterStatus();
      filterStatusList.add(status);
    } else {
      // Jika "all" ada, hapus dari list sebelum menambahkan status baru
      if (filterStatusList.any((element) => element['value'] == "all")) {
        filterStatusList.removeWhere((element) => element['value'] == "all");
      }

      // Tambahkan status baru jika belum ada di dalam list
      if (!filterStatusList.contains(status)) {
        filterStatusList.add(status);
      }
    }
  }

  void deleteFilterStatus(Map<String, String> status) {
    filterStatusList.remove(status);
  }

  void clearFilterStatus() {
    filterStatusList.clear();
  }

  void clearFilterClientSource() {
    filterClientSource.value = null;
  }

  // ADD, DELETE, CLEAR CLIENT SOURCE
  void addFilterClientSource(Map<String, String> clientSource) {
    // Cek jika status yang dipilih adalah "all"
    if (clientSource['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearFilterClientSource();
    } else {
      filterClientSource.value = clientSource;
    }
  }

  void deleteFilterClientSource() {
    filterClientSource.value = null;
  }

  void addFilterPic(Map<String, String> pic) {
    // Cek jika status yang dipilih adalah "all"
    if (pic['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearFilterPic();
    } else {
      filterPic.value = pic;
      // // Jika "all" ada, hapus dari list sebelum menambahkan status baru
      // if (filterPicList.any((element) => element['value'] == "all")) {
      //   filterPicList.removeWhere((element) => element['value'] == "all");
      // }

      // // Tambahkan status baru jika belum ada di dalam list
      // if (!filterPicList.contains(pic)) {
      //   filterPicList.add(pic);
      // }
    }
  }

  void deleteFilterPic() {
    filterPic.value = null;
  }

  void clearFilterPic() {
    filterPic.value = null;
  }

  // ADD, DELETE, CLEAR Filter Category
  void addFilterCategory(Map<String, String> category) {
    // Cek jika status yang dipilih adalah "all"
    if (category['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearFilterCategory();
      filterCategoryList.add(category);
    } else {
      // Jika "all" ada, hapus dari list sebelum menambahkan status baru
      if (filterCategoryList.any((element) => element['value'] == "all")) {
        filterCategoryList.removeWhere((element) => element['value'] == "all");
      }

      // Tambahkan status baru jika belum ada di dalam list
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

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String filter) {
    List result = [];
    // fetchFilter();

    // Debugging
    print("Current Filter: $filter");
    print("Current Search Query: ${search.value}");

    if (filter.toLowerCase() == 'status') {
      result = statusList;

      // Debugging
      // print("Status List: $statusList");

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((status) {
          // print("Checking status: ${status['value']} - ${status['label']}");
          return status['value'].toLowerCase().contains(query) || status['label'].toLowerCase().contains(query);
        }).toList();
      }
    } else if (filter.toLowerCase() == 'client_source') {
      result = clientSourceList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((clientSource) {
          print("Checking client source: ${clientSource['value']} - ${clientSource['label']}");
          return clientSource['value'].toLowerCase().contains(query) ||
              clientSource['label'].toLowerCase().contains(query);
        }).toList();
      }

      // Filter PIC
    } else if (filter.toLowerCase() == 'pic') {
      result = picList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((pic) {
          print("Checking PIC: ${pic['value']} - ${pic['label']}");
          return pic['value'].toLowerCase().contains(query) || pic['label'].toLowerCase().contains(query);
        }).toList();
      }

      // Filter Category
    } else if (filter.toLowerCase() == 'category') {
      result = categoryList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((category) {
          print("Checking Category: ${category['value']} - ${category['label']}");
          return category['value'].toLowerCase().contains(query) || category['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  void filterByStatus() {
    quotationController.clearFilterStatus();
    for (final data in filterStatusList) {
      switch (data['value']) {
        case 'all':
          quotationController.clearFilterStatus();
          break;
        default:
          quotationController.addFilterStatus(data['value'].toString());
          break;
      }
    }
    clearFilterStatus();
  }

  void filterByClientSource() {
    quotationController.clearFilterClientSource();
    dashboardController.clearFilterClientSource();

    if (filterClientSource.value != null) {
      String clientSourceValue = filterClientSource.value!['value'].toString();

      quotationController.addFilterClientSource(clientSourceValue);
      dashboardController.addFilterClientSource(clientSourceValue);
    }

    clearFilterClientSource();
  }

  void filterByPIC() {
    quotationController.clearFilterPic();
    dashboardController.clearFilterPic();

    if (filterPic.value != null) {
      String picValue = filterPic.value!['value'].toString();
      quotationController.addFilterPic(picValue);
      dashboardController.addFilterPic(picValue);
    }

    clearFilterPic();
  }

  void filterByCategory() {
    quotationController.clearFilterCategory();
    dashboardController.clearFilterCategory();

    for (var data in filterCategoryList) {
      // Convert both values to lowercase to ensure case-insensitive comparison
      String categoryValue = data['value'].toString();

      quotationController.addFilterCategory(categoryValue);
      dashboardController.addFilterCategory(categoryValue);
    }

    clearFilterCategory();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    if (start != null && end == null) {
      end = DateTime.now();
    }
    startDate.value = start;
    endDate.value = end;
  }

  void filterByDateRange() {
    quotationController.clearFilterDate();
    dashboardController.clearDataRange();

    quotationController.filterStartDate.value = startDate.value;
    quotationController.filterEndDate.value = endDate.value;

    dashboardController.filterStartDate.value = startDate.value;
    dashboardController.filterEndDate.value = endDate.value;

    startDate.value = null;
    endDate.value = null;
  }

  void searchFilter(String filter) {
    print(filter);

    if (filter.toLowerCase() == "all") {
      filterByDateRange();
      filterByCategory();
      filterByClientSource();
      filterByPIC();

      // Filter Client Source
    } else if (filter.toLowerCase() == 'client source') {
      filterByClientSource();

      // Filter PIC
    } else if (filter.toLowerCase() == 'pic') {
      filterByPIC();

      // Filter category
    } else if (filter.toLowerCase() == 'category') {
      filterByCategory();
    }

    dashboardController.saveDashboardData();

    Get.until((route) => Get.currentRoute == AppRoutes.home);
  }
}

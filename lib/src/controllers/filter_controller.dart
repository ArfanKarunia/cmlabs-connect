import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/dashboard_controller.dart';
import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../constant/config.dart';
import '../constant/const.dart';

class FilterController extends GetxController {
  var search = Rx<String?>(null);

  // Menyimpan list status
  var statusList = <Map<String, String>>[].obs;
  var clientSourceList = <Map<String, String>>[].obs;
  var picList = <Map<String, String>>[].obs;
  var categoryList = <Map<String, String>>[].obs;

  // Menyimpan Filter
  var filterStatusList = <Map<String, String>>[].obs;
  var filterClientSourceList = <Map<String, String>>[].obs;
  var filterPicList = <Map<String, String>>[].obs;
  var filterCategoryList = <Map<String, String>>[].obs;

  // Menyimpan Filter Tanggal
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);

  // Inisialisasi Dio dan AuthenticationController
  final Dio dio = Dio();
  final AuthenticationController authenticationController = Get.find();
  final QuotationController quotationController =
      Get.put(QuotationController());
  final DashboardController dashboardController =
      Get.put(DashboardController());

  final String baseUrl = Config.baseURL;

  @override
  void onInit() {
    super.onInit();
    // fetchList();
  }

  // Fetch data status dari API
  Future<void> fetchList(String filter) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // untuk Filter Status
      if (filter.toLowerCase() == "status") {
        final response = await dio.get(
          '$baseUrl/filter/status',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          var responseData = response.data['data'];

          var mappedData = responseData.map<Map<String, String>>((status) {
            return {
              'value': status['value']?.toString() ?? '',
              'label': status['label']?.toString() ?? '',
            };
          }).toList();

          statusList.assignAll(mappedData);
        }

        // Untuk Filter Client Source
      } else if (filter.toLowerCase() == 'client_source') {
        final response = await dio.get(
          '$baseUrl/filter/client_source',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          var responseData = response.data['data'];

          var mappedData =
              responseData.map<Map<String, String>>((clientSource) {
            return {
              'value': clientSource['value']?.toString() ?? '',
              'label': clientSource['label']?.toString() ?? '',
            };
          }).toList();

          clientSourceList.assignAll(mappedData);
        }
      } else if (filter.toLowerCase() == 'pic') {
        final response = await dio.get(
          '$baseUrl/filter/pic',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          var responseData = response.data['data'];

          var mappedData = responseData.map<Map<String, String>>((pic) {
            return {
              'value': pic['value']?.toString() ?? '',
              'label': pic['label']?.toString() ?? '',
            };
          }).toList();

          picList.clear();

          picList.add({'value': 'all', 'label': 'All'});
          picList.addAll(mappedData);
        }
      } else if (filter.toLowerCase() == 'category') {
        final response = await dio.get(
          '$baseUrl/filter/data_services',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          var responseData = response.data['data'];

          var mappedData = responseData.map<Map<String, String>>((category) {
            return {
              'value': category['id']?.toString() ?? '',
              'label': category['text']?.toString() ?? '',
            };
          }).toList();

          categoryList.clear();

          categoryList.add({'value': 'all', 'label': 'All'});
          categoryList.addAll(mappedData);
        }
      }
    } catch (e) {
      print('Error fetching status data: $e');
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
    filterClientSourceList.clear();
  }

  // ADD, DELETE, CLEAR CLIENT SOURCE
  void addFilterClientSource(Map<String, String> clientSource) {
    // Cek jika status yang dipilih adalah "all"
    if (clientSource['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearFilterClientSource();
      filterClientSourceList.add(clientSource);
    } else {
      // Jika "all" ada, hapus dari list sebelum menambahkan status baru
      if (filterClientSourceList.any((element) => element['value'] == "all")) {
        filterClientSourceList
            .removeWhere((element) => element['value'] == "all");
      }

      // Tambahkan status baru jika belum ada di dalam list
      if (!filterClientSourceList.contains(clientSource)) {
        filterClientSourceList.add(clientSource);
      }
    }
  }

  void deleteFilterClientSource(Map<String, String> clientSource) {
    filterClientSourceList.remove(clientSource);
  }

  void addFilterPic(Map<String, String> pic) {
    // Cek jika status yang dipilih adalah "all"
    if (pic['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearFilterPic();
      filterPicList.add(pic);
    } else {
      // Jika "all" ada, hapus dari list sebelum menambahkan status baru
      if (filterPicList.any((element) => element['value'] == "all")) {
        filterPicList.removeWhere((element) => element['value'] == "all");
      }

      // Tambahkan status baru jika belum ada di dalam list
      if (!filterPicList.contains(pic)) {
        filterPicList.add(pic);
      }
    }
  }

  void deleteFilterPic(Map<String, String> status) {
    filterPicList.remove(status);
  }

  void clearFilterPic() {
    filterPicList.clear();
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
    // fetchList();

    // Debugging
    print("Current Filter: ${filter}");
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
          return status['value'].toLowerCase().contains(query) ||
              status['label'].toLowerCase().contains(query);
        }).toList();
      }
    } else if (filter.toLowerCase() == 'client_source') {
      result = clientSourceList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((clientSource) {
          print(
              "Checking client source: ${clientSource['value']} - ${clientSource['label']}");
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
          return pic['value'].toLowerCase().contains(query) ||
              pic['label'].toLowerCase().contains(query);
        }).toList();
      }

      // Filter Category
    } else if (filter.toLowerCase() == 'category') {
      result = categoryList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((category) {
          print(
              "Checking Category: ${category['value']} - ${category['label']}");
          return category['value'].toLowerCase().contains(query) ||
              category['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  void filterByStatus() {
    quotationController.clearFilterStatus();
    for (var data in filterStatusList) {
      switch (data['value']) {
        case 'all':
          quotationController.clearFilterStatus();
          break;
        case 'new':
          quotationController.addFilterStatus(StatusLead.newLead);
          break;
        case 'followed-up':
          quotationController.addFilterStatus(StatusLead.followedUp);
          break;
        case 'accepted':
          quotationController.addFilterStatus(StatusLead.accepted);
          break;
        case 'rejected':
          quotationController.addFilterStatus(StatusLead.rejected);
          break;
      }
    }
    clearFilterStatus();
  }

  void filterByClientSource() {
    quotationController.clearFilterClientSource();
    dashboardController.clearFilterClientSource();

    for (var data in filterClientSourceList) {
      // Convert both values to lowercase to ensure case-insensitive comparison
      String clientSourceValue = data['value'].toString().toLowerCase();

      quotationController.addFilterClientSource(clientSourceValue);
      print("Client Source : ${clientSourceValue}");
      dashboardController.addFilterClientSource(StringUtils.toCamelCase(clientSourceValue));
    }

    clearFilterClientSource();
  }

  void filterByPIC() {
    quotationController.clearFilterPic();
    dashboardController.clearFilterPic();

    for (var data in filterPicList) {
      // Convert both values to lowercase to ensure case-insensitive comparison
      String picValue = data['value'].toString().toLowerCase();

      quotationController.addFilterPic(picValue);
      dashboardController.addFilterPic(StringUtils.toCamelCase(picValue));
    }

    clearFilterPic();
  }

  void filterByCategory() {
    quotationController.clearFilterCategory();
    dashboardController.clearFilterCategory();

    for (var data in filterCategoryList) {
      // Convert both values to lowercase to ensure case-insensitive comparison
      String categoryValue = data['value'].toString().toLowerCase();

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
    quotationController.clearDataRange();
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

    Get.until((route) => Get.currentRoute == '/home');
  }
}

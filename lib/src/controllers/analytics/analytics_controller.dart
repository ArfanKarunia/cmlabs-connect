import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../constant/config.dart';
import '../../models/analytics/quotation_traffic_model.dart';
import '../user/user_controller.dart';

// Definisi enum SortOption dipindahkan ke sini
enum SortOption {
  newestDate,
  oldestDate,
  newMost,
  newLeast,
  acceptedMost,
  acceptedLeast,
  rejectedMost,
  rejectedLeast,
  followUpMost,
  followUpLeast,
  totalMost,
  totalLeast,
}

enum QuotationTrafficType { daily, weekly }

class AnalyticsController extends GetxController {
  // Analytics Data
  Rx<QuotationTraffic?> quotationTraffic = Rx<QuotationTraffic?>(null);

  // Variabel untuk Top Services & PIC (jika ada)
  RxList<dynamic> topServicesList = <dynamic>[].obs;
  RxList<dynamic> picList = <dynamic>[].obs;

    // --- START: VARIABEL BARU UNTUK STATE TOMBOL SAVE ---
  RxBool hasFilterChanged = false.obs;

  // --- START: ANALYTICS FILTER STATE BARU ---
  Rx<DateTime?> filterStartDate = Rx<DateTime?>(null); // Untuk tanggal mulai filter
  Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);   // Untuk tanggal selesai filter

  // RxString untuk menyimpan pilihan filter tunggal (nama atau ID)
  RxString selectedCategory = 'All'.obs;
  RxString selectedPic = 'All'.obs;
  RxString selectedClientSource = 'All'.obs;
  RxString selectedUtm = 'All'.obs;
  RxString selectedStatus = 'All'.obs;
  // --- END: ANALYTICS FILTER STATE BARU ---

  // Analytics Sort By
  Rx<SortOption?> selectedSortOption = Rx<SortOption?>(SortOption.newestDate);

  // --- START: DUMMY DATA UNTUK FILTER OPTIONS ---
  // Ganti ini dengan data yang diambil dari API jika opsi-opsinya dinamis
  final List<String> categoriesOptions = [
    'All', 'SEO Services', 'SEO Content Writing', 'SEM',
    'Social Media Management', 'Digital Marketing'
  ];
  final List<String> picOptions = [
    'All', 'Vanessa', 'Larasati', 'Agita Ayudya', 'Bobby Pranata', 'Arfan', 'Naufal', 'Pasha'
  ];
  final List<String> clientSourceOptions = [
    'All', 'Direct Email', 'Web WhatsApp', 'SEM',
    'Direct LinkedIn', 'Direct Partnership'
  ];
  final List<String> utmOptions = [
    'All', 'Google & GDN', 'Google & CPC', 'Meta & GDN', 'Meta & Carousel'
  ];
  final List<String> statusOptions = [
    'All', 'New', 'Followed Up', 'Accepted', 'Rejected'
  ];
  // --- END: DUMMY DATA UNTUK FILTER OPTIONS ---


  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final UserController userController = Get.find<UserController>();

 

  @override
  void onReady() {
    super.onReady(); // Gunakan onReady() di sini
    fetchQuotationTraffic(QuotationTrafficType.daily);
    // Jika Anda ingin fetch Top Services dan PIC juga di awal, panggil di sini
    // fetchTopServices();
    // fetchPics();

    // Inisialisasi tanggal filter awal jika diperlukan (misal: 1 bulan terakhir)
    // filterEndDate.value = DateTime.now();
    // filterStartDate.value = DateTime.now().subtract(const Duration(days: 30));
  }

// --- START: MODIFIKASI FILTER METHODS ---
  void setFilterStartDate(DateTime? date) {
    if (filterStartDate.value != date) { // Cek apakah ada perubahan
      filterStartDate.value = date;
      hasFilterChanged.value = true; // Set true jika ada perubahan
    }
    debugPrint('Filter Start Date set to: ${filterStartDate.value}');
  }

  void setFilterEndDate(DateTime? date) {
    if (filterEndDate.value != date) { // Cek apakah ada perubahan
      filterEndDate.value = date;
      hasFilterChanged.value = true; // Set true jika ada perubahan
    }
    debugPrint('Filter End Date set to: ${filterEndDate.value}');
  }

  void updateFilter(String filterType, String value) {
    // Ambil RxString yang sesuai
    RxString? targetRx;
    switch (filterType) {
      case 'category': targetRx = selectedCategory; break;
      case 'pic': targetRx = selectedPic; break;
      case 'clientSource': targetRx = selectedClientSource; break;
      case 'utm': targetRx = selectedUtm; break;
      case 'status': targetRx = selectedStatus; break;
      default: debugPrint('Unknown filter type: $filterType');
    }

    if (targetRx != null && targetRx.value != value) { // Cek apakah ada perubahan
      targetRx.value = value;
      hasFilterChanged.value = true; // Set true jika ada perubahan
    }
    debugPrint('Filter $filterType updated to: $value');
  }

  void applyFilters() {
    // ... (kode yang sudah ada)
    hasFilterChanged.value = false; // Reset state setelah filter diterapkan
    Get.back();
  }

  void clearFilters() {
    // ... (kode yang sudah ada untuk membersihkan filter)
    hasFilterChanged.value = false; // Reset state setelah filter dibersihkan
    debugPrint('Filters Cleared!');
  }
  // --- END: FILTER METHODS BARU ---


  // Metode setSelectedSortOption tetap sama
  void setSelectedSortOption(SortOption? option) {
    selectedSortOption.value = option;
    // Di sini Anda bisa memicu fetch data utama dengan opsi sort baru
    // Misalnya: fetchQuotationOverviewData(sortOption: option);
    debugPrint('Sort Option Selected: ${option?.name}');
  }

  // Metode fetchQuotationTraffic, fetchTopServices, fetchPics tetap sama
  Future<void> fetchQuotationTraffic(QuotationTrafficType type) async {
    try {
      String? accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('Access token not available for quotation traffic fetch.');
        return;
      }
      final response = await dio.get(
        '$baseUrl/quotation/analytics?date_type=${type.name}',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        quotationTraffic.value = QuotationTraffic.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching quotation traffic data: $e');
    }
  }

  Future<void> fetchTopServices({
    String dateType = 'custom',
    String startDate = '2000-01-01',
    String endDate = '2025-12-30',
    String status = 'accepted',
    String utm = 'GoogleL2CDC', // Sesuai Postman Anda
    String sortBy = 'percentage:desc',
  }) async {
    try {
      String? accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('Access token not available for top services fetch.');
        return;
      }
      final String apiUrl = '$baseUrl/quotation/getTopRequestedServices?'
          'date_type=$dateType&'
          'start_date=$startDate&'
          'end_date=$endDate&'
          'status=$status&'
          'utm=$utm';
      debugPrint('Fetching Top Services from: $apiUrl');
      final response = await dio.get(
        apiUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        topServicesList.value = response.data['data'] as List<dynamic>;
        debugPrint('Top services fetched successfully: ${topServicesList.length} items');
      } else {
        debugPrint('Failed to fetch top services: Status Code ${response.statusCode}, Data: ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error fetching top services: ${e.response?.statusCode} - ${e.message}');
      if (e.response?.data != null) {
        debugPrint('Top Services Error Data: ${e.response?.data}');
      }
    } catch (e) {
      debugPrint('General Error fetching top services: $e');
    }
  }

  Future<void> fetchPics({
    String dateType = 'custom',
    String startDate = '2000-01-01',
    String endDate = '2025-12-30',
    String status = 'accepted',
    String utm = 'GoogleL2CPC', // Sesuai Postman Anda
    List<String> categories = const ['seo services'],
    String sortBy = 'percentage:desc',
  }) async {
    try {
      String? accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('Access token not available for PIC fetch.');
        return;
      }
      Map<String, dynamic> queryParams = {
        'date_type': dateType,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
        'utm': utm,
        'sort_by': sortBy,
      };
      for (int i = 0; i < categories.length; i++) {
        queryParams['category[$i]'] = categories[i];
      }
      final String apiUrl = '$baseUrl/quotation/getTopPic';
      debugPrint('Fetching PICs from: $apiUrl with params: $queryParams');
      final response = await dio.get(
        apiUrl,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        picList.value = response.data['data'] as List<dynamic>;
        debugPrint('PICs fetched successfully: ${picList.length} items');
      } else {
        debugPrint('Failed to fetch PICs: Status Code ${response.statusCode}, Data: ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error fetching PICs: ${e.response?.statusCode} - ${e.message}');
      if (e.response?.data != null) {
        debugPrint('PICs Error Data: ${e.response?.data}');
      }
    } catch (e) {
      debugPrint('General Error fetching PICs: $e');
    }
  }
}
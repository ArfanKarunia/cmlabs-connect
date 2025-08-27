import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/inbox/quotation_model.dart';
import '../../../utils/toast.dart';
import '../inbox_controller.dart';
import '../../user/user_controller.dart';

class QuotationController extends InboxController {
  RxList<Quotation> quotationList = <Quotation>[].obs;

  Rx<int> newestIdQuotation = Rx<int>(0);
  Rx<int> newQuotationCount = Rx<int>(0);

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final UserController userController = Get.find<UserController>();

  @override
  Future<void> fetchList({
    bool isLoadMore = false,
    bool refreshData = false,
  }) async {
    try {
      String? accessToken = userController.accesToken.value;

      if (refreshData) {
        start.value = 0;
        limit.value = quotationList.isNotEmpty ? quotationList.length : 10;
      }

      if (!isLoadMore && !refreshData) {
        isLoading(true);
        await Future.delayed(Durations.short2);

        start.value = 0;
        limit.value = 10;
      }

      String url = constructFilteredUrl('$baseUrl/dashboard/data_recent_quotation');

      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = response.data['total'];
        totalLeads.value = res;

        final rawData = response.data['data'];
        if (rawData != null && rawData is List) {
          List<Quotation> quotations = rawData.map<Quotation>((item) {
            return Quotation.fromJson(item);
          }).toList();

          if (isLoadMore) {
            quotationList.addAll(quotations);
          } else {
            quotationList.value = quotations;
          }

          if (refreshData) limit.value = 10;
        }
      }
    } catch (_) {
    } finally {
      if (!isLoadMore) isLoading(false);
    }
  }

  // Quotation cannot be exported
  @override
  Future<void> exportData() async {}
  /*
  
    FUNGSI Check new Data Quotation

    fungsi ini berfungsi untuk mengecek data terbaru dari API

  */

  // void checkNewQuotationsPeriodically() {
  //   if (userController.accesToken.value != null) {
  //     Timer.periodic(const Duration(seconds: 10), (timer) async {
  //       await dashboardController.saveDashboardData();
  //       await fetchCheckNewData();
  //       print("check new data : ${newQuotationCount.value}");
  //     });
  //   }
  // }

  Future<void> refreshNewData() async {
    try {
      // Jika data belum ada di local storage, fetch data dari API
      String? accessToken = userController.accesToken.value;
      int start = 0;
      int limit = 1;

      final response = await dio.get(
        '$baseUrl/dashboard/data_recent_quotation?start=$start&limit=$limit',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<Quotation> quotations = rawData.map<Quotation>((item) {
            return Quotation.fromJson(item);
          }).toList();

          newestIdQuotation.value = quotations.first.id ?? 1;
          newQuotationCount.value = 0;
        }
      }
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

  Future<void> fetchCheckNewData() async {
    try {
      // Jika data belum ada di local storage, fetch data dari API
      String? accessToken = userController.accesToken.value;
      int start = 0;
      int limit = 1;

      final response = await dio.get(
        '$baseUrl/dashboard/data_recent_quotation?start=$start&limit=$limit',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<Quotation> quotations = rawData.map<Quotation>((item) {
            return Quotation.fromJson(item);
          }).toList();

          int? newQuotationId = quotations.first.id;

          if (newestIdQuotation.value < (newQuotationId ?? 1)) {
            newQuotationCount.value = (newQuotationId ?? 1) - newestIdQuotation.value;
            newestIdQuotation.value = newQuotationId ?? 1;
          }

          // print("check new data : ${newQuotationCount.value}");
        }
      }
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

  @override
  Future<void> resetList() async {
    start.value = 0;
    quotationList.clear();

    clearAll();
    await fetchList();
  }

  /*
  
    FUNGSI Filtered Quotation

    Fungsi ini digunakan untuk mengembalikan List Data Quotation sesuai dengan search dan filter dari user

  */
  List<Quotation> get filteredQuotations {
    List<Quotation> result = List.from(quotationList);

    // Jika search tidak kosong, lakukan pencarian berdasarkan nama atau field lain
    // Filter berdasarkan pencarian (search) jika search tidak kosong
    if (search.value != null && search.value!.isNotEmpty) {
      final query = search.value!.toLowerCase();

      result = result.where((quotation) {
        return (quotation.email?.toLowerCase().contains(query) ?? false) ||
            (quotation.section?.toLowerCase().contains(query) ?? false) ||
            (quotation.data?.company?.toLowerCase().contains(query) ?? false) ||
            (quotation.data?.name?.toLowerCase().contains(query) ?? false) ||
            (quotation.data?.category?.any((cat) => cat.toLowerCase().contains(query)) ?? false) ||
            (quotation.data?.clientSource?.value?.toLowerCase().contains(query) ?? false) ||
            (quotation.data?.phoneNumber?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }

  @override
  Future<void> deleteData(int? id) async {
    try {
      final accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty || id == null) {
        showErrorToast('Gagal menghapus Quotation');
      }

      final response = await dio.delete(
        '$baseUrl/quotation/delete/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        quotationList.removeWhere((quotation) => quotation.id == id);
        totalLeads.value -= 1;
        showSuccessToast('Berhasil menghapus Quotation');
      } else {
        showErrorToast('Gagal menghapus Quotation');
        // debugPrint("Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      // debugPrint('Error fetching data: $e');
      showErrorToast('Terjadi kesalahan saat menghapus data');
    }
  }
}

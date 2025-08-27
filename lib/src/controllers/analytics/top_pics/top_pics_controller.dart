// ignore_for_file: overridden_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/top_pics_model.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/toast.dart';
import '../analytics_controller.dart';

class TopPICsController extends AnalyticsController {
  Rx<TopPICs?> topPICs = Rx<TopPICs?>(null);

  // Weekly, Monthly or Yearly
  @override
  Rx<DateType?> initialDateType = (DateType.weekly).obs;
  @override
  Rx<DateType?> selectedDateType = (DateType.weekly).obs;

  @override
  Rx<SortOption?> selectedSortOption = (SortOption.totalMost).obs;

  TopPICs? get data => topPICs.value;
  int get dataLength => data?.topPics.length ?? 0;

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  @override
  Future<void> fetchData() async {
    try {
      isLoading(true);
      await Future.delayed(Durations.short2);

      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        constructFilteredUrl(
          '$baseUrl/quotation/getTopPIC',
          analyticsType: AnalyticsType.topPICs,
          dateType: selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        topPICs.value = TopPICs.fromJson(response.data);
      }
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> exportData() async {
    if (isExportLoading.isTrue) return;
    isExportLoading(true);

    try {
      String? accessToken = userController.accesToken.value;

      await PermissionUtils().requestStoragePermission();

      final response = await dio.get(
        constructFilteredUrl(
          '$baseUrl/quotation/exportTopPICExcel',
          analyticsType: AnalyticsType.topPICs,
          dateType: selectedDateType.value,
        ),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final fileName = FileUtils.getFilenameFromResponse(response);
        final filePath = await FileUtils.saveFile(response.data, fileName);

        showSuccessToast('Data tersimpan di $filePath');
        FileUtils.openFile(filePath);
      }
    } on DioException catch (e) {
      showErrorToast('Failed to export data: ${e.message}');
    } catch (e) {
      showErrorToast('Failed to export data: ${e.toString()}');
    } finally {
      isExportLoading(false);
    }
  }
}

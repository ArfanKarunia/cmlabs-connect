// ignore_for_file: overridden_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/top_services_model.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/toast.dart';
import '../analytics_controller.dart';

class TopServicesController extends AnalyticsController {
  Rx<TopServices?> topServices = Rx<TopServices?>(null);

  // Weekly, Monthly or Yearly
  @override
  Rx<DateType?> initialDateType = (DateType.weekly).obs;
  @override
  Rx<DateType?> selectedDateType = (DateType.weekly).obs;

  @override
  Rx<SortOption?> selectedSortOption = (SortOption.totalMost).obs;

  TopServices? get data => topServices.value;
  int get dataLength => data?.topServices.length ?? 0;

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
          '$baseUrl/quotation/getTopRequestedServices',
          analyticsType: AnalyticsType.topServices,
          dateType: selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        topServices.value = TopServices.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        topServices.value = null;
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
          '$baseUrl/quotation/exportTopRequestedServicesExcel',
          analyticsType: AnalyticsType.topServices,
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

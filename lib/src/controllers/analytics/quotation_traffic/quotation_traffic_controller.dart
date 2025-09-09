// ignore_for_file: overridden_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/quotation_traffic_model.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/toast.dart';
import '../analytics_controller.dart';

class QuotationTrafficController extends AnalyticsController {
  Rx<QuotationTraffic?> quotationTraffic = Rx<QuotationTraffic?>(null);

  // Weekly or Daily
  @override
  Rx<DateType?> initialDateType = (DateType.daily).obs;
  @override
  Rx<DateType?> selectedDateType = (DateType.daily).obs;

  QuotationTraffic? get data => quotationTraffic.value;
  int get dataLength => data?.labels.length ?? 0;

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
          '$baseUrl/quotation/analytics',
          analyticsType: AnalyticsType.quotationTraffic,
          dateType: selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        quotationTraffic.value = QuotationTraffic.fromJson(response.data);
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
          '$baseUrl/quotation/exportQuotationAnalyticsExcel',
          analyticsType: AnalyticsType.quotationTraffic,
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

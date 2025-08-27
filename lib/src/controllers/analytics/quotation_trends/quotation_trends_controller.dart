// ignore_for_file: overridden_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/quotation_trends_model.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/toast.dart';
import '../analytics_controller.dart';

class QuotationTrendsController extends AnalyticsController {
  Rx<QuotationTrends?> quotationTrends = Rx<QuotationTrends?>(null);

  // Monthly or Yearly
  @override
  Rx<DateType?> initialDateType = (DateType.monthly).obs;
  @override
  Rx<DateType?> selectedDateType = (DateType.monthly).obs;

  QuotationTrends? get data => quotationTrends.value;
  CompareData? get compareLastTwo => data?.compareLastTwo;
  List<QuotationTrendsData>? get lineChart => data?.lineChart;
  int get dataLength => data?.lineChart.length ?? 0;

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
          '$baseUrl/quotation/getQuotationTrendsLineChart',
          analyticsType: AnalyticsType.quotationTrends,
          dateType: selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        quotationTrends.value = QuotationTrends.fromJson(response.data);
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
          '$baseUrl/quotation/exportQuotationTrendsExcel',
          analyticsType: AnalyticsType.quotationTrends,
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

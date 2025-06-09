import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/quotation_traffic_model.dart';
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
  Future<void> fetchData({DateType? dateType}) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        constructFilteredUrl(
          '$baseUrl/quotation/analytics',
          analyticsType: AnalyticsType.quotationTraffic,
          dateType: dateType ?? selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        quotationTraffic.value = QuotationTraffic.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching quotation traffic data: $e');
    }
  }
}

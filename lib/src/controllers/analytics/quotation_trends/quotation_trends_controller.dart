import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/quotation_trends_model.dart';
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

  @override
  Future<void> fetchData({DateType? dateType}) async {
    try {
      String? accessToken = userController.accesToken.value;
      final response = await dio.get(
        constructFilteredUrl(
          '$baseUrl/quotation/getQuotationTrendsLineChart',
          analyticsType: AnalyticsType.quotationTrends,
          dateType: dateType ?? selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        quotationTrends.value = QuotationTrends.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching quotation trends data: $e');
    }
  }
}

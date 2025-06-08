// ignore_for_file: overridden_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/top_pics_model.dart';
import '../analytics_controller.dart';

class TopPICsController extends AnalyticsController {
  Rx<TopPICs?> topPICs = Rx<TopPICs?>(null);

  // Weekly, Monthly or Yearly
  @override
  Rx<DateType?> initialDateType = (DateType.weekly).obs;
  @override
  Rx<DateType?> selectedDateType = (DateType.weekly).obs;

  TopPICs? get data => topPICs.value;
  int get dataLength => data?.topPics.length ?? 0;

  @override
  Rx<SortOption?> selectedSortOption = (SortOption.totalMost).obs;

  @override
  Future<void> fetchData({DateType? dateType}) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        constructFilteredUrl(
          '$baseUrl/quotation/getTopPIC',
          analyticsType: AnalyticsType.topPICs,
          dateType: dateType ?? selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        topPICs.value = TopPICs.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching top PICs data: $e');
    }
  }
}

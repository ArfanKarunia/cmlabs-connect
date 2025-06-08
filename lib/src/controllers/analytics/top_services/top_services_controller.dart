import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/analytics/top_services_model.dart';
import '../analytics_controller.dart';

class TopServicesController extends AnalyticsController {
  Rx<TopServices?> topServices = Rx<TopServices?>(null);

  // Weekly, Monthly or Yearly
  @override
  Rx<DateType?> initialDateType = (DateType.weekly).obs;
  @override
  Rx<DateType?> selectedDateType = (DateType.weekly).obs;

  @override
  Future<void> fetchData({DateType? dateType}) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        constructFilteredUrl(
          '$baseUrl/quotation/getTopRequestedServices',
          analyticsType: AnalyticsType.topServices,
          dateType: dateType ?? selectedDateType.value,
        ),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        topServices.value = TopServices.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching top services data: $e');
    }
  }
}

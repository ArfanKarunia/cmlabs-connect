import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/config.dart';
import '../../models/analytics/quotation_traffic_model.dart';
import '../user/user_controller.dart';

enum QuotationTrafficType { daily, weekly }

class AnalyticsController extends GetxController {
  // Analytics Data
  Rx<QuotationTraffic?> quotationTraffic = Rx<QuotationTraffic?>(null);

  // Analytics Filter
  Rx<Map<String, String>?> selectedCategory = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> selectedPic = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> selectedClientSource = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> selectedUtm = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> selectedStatus = Rx<Map<String, String>?>(null);

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final UserController userController = Get.find<UserController>();

  @override
  void onReady() {
    super.onInit();
    fetchQuotationTraffic(QuotationTrafficType.daily);
  }

  Future<void> fetchQuotationTraffic(QuotationTrafficType type) async {
    try {
      String? accessToken = userController.accesToken.value;
      final response = await dio.get(
        '$baseUrl/quotation/analytics?date_type=${type.name}',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        quotationTraffic.value = QuotationTraffic.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }
}

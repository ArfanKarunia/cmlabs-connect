import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../services/firebase_analytics_service.dart';
import '../../../constant/config.dart';
import '../../../constant/const.dart';
import '../../../models/inbox/property/project_history_model.dart';
import '../../../models/inbox/property/url_tracking.dart';
import '../../../models/inbox/quotation_model.dart';
import '../../user/user_controller.dart';
import 'quotation_controller.dart';

class DetailQuotationController extends GetxController {
  Rx<Quotation?> quotation = Rx<Quotation?>(null);
  Rx<String?> pitchingDuration = Rx<String?>(null);

  final QuotationController parentController = Get.find<QuotationController>();
  final FirebaseAnalyticsService analyticsService = Get.find<FirebaseAnalyticsService>();

  final UserController userController = Get.find<UserController>();
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Future<void> fetchDetails(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/quotation/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      // For url tracking
      final response2 = await dio.get(
        '$baseUrl/quotation/detail/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final previousData = parentController.quotationList.where((element) => element.id == id).first;
        final Quotation data = Quotation.fromDetail(response.data['data']);

        quotation.value = previousData.copyWith(data: data.data);
        quotation.value = quotation.value?.copyWith(
            data: quotation.value?.data?.copyWith(
              remarks: response.data['data']['data']['remarks'],
              notes: response.data['data']['data']['notes'],
              type: response2.data['data']['typeInformation'] is List
                  ? List<String>.from(response2.data['data']['typeInformation'])
                  : [response2.data['data']['typeInformation']],
              urlTracking: response2.data['data']['url_tracking'] != null
                  ? UrlTracking.fromJson(response2.data['data']['url_tracking'])
                  : quotation.value?.data?.urlTracking,
            ),
            activities: response2.data['activities'] != null
                ? (response2.data['activities'] as List<dynamic>?)
                        ?.map((activityJson) => ProjectHistory.fromJson(activityJson))
                        .toList() ??
                    []
                : null);
        pitchingDuration.value = timeago.format(quotation.value?.createdAt ?? DateTime.now());
      }

      await analyticsService.logEvent('fetch_detail_inbox', parameters: {
        'id': id,
        'feature': 'quotation',
        'client': quotation.value?.data?.name ?? quotation.value?.data?.company ?? '',
        'joined_at': quotation.value?.createdAt.toString() ?? '',
        'status': statusLead[quotation.value?.status ?? 0].title,
      });
    } catch (e) {
      rethrow;
    }
  }
}

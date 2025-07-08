import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../services/firebase_analytics_service.dart';
import '../../../constant/config.dart';
import '../../../constant/const.dart';
import '../../../models/inbox/faq_model.dart';
import '../../user/user_controller.dart';

class DetailFaqController extends GetxController {
  Rx<Faq?> faq = Rx<Faq?>(null);

  Rx<bool> isLoading = false.obs;

  final FirebaseAnalyticsService analyticsService = Get.find<FirebaseAnalyticsService>();

  final UserController userController = Get.find<UserController>();
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Future<void> fetchDetails(int id) async {
    try {
      isLoading(true);

      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/faq/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];
        faq.value = Faq.fromJson(rawData);
      }

      await analyticsService.logEvent('fetch_detail_inbox', parameters: {
        'id': id,
        'feature': 'faq',
        'question': faq.value?.question ?? '',
        'joined_at': faq.value?.createdAt.toString() ?? '',
        'status': statusLead[faq.value?.status ?? 0].title,
      });

      isLoading(false);
    } catch (e) {
      rethrow;
    }
  }
}

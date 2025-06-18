import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constant/config.dart';
import '../../../models/inbox/quotation_model.dart';
import '../../user/user_controller.dart';

class DetailQuotationController extends GetxController {
  Rx<DetailQuotation?> quotation = Rx<DetailQuotation?>(null);
  Rx<String?> pitchingDuration = Rx<String?>(null);

  final UserController userController = Get.find<UserController>();
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Future<void> fetchDetails(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/quotation/detail/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        quotation.value = DetailQuotation.fromJson(data);
        pitchingDuration.value = timeago.format(quotation.value?.createdAt ?? DateTime.now());
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/faq_model.dart';
import '../../user/user_controller.dart';

class DetailFaqController extends GetxController {
  Rx<Faq?> faq = Rx<Faq?>(null);

  Rx<bool> isLoading = false.obs;

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

      isLoading(false);
    } catch (e) {
      rethrow;
    }
  }
}

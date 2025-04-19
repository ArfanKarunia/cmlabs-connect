import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/contact_us_model.dart';
import '../../user/user_controller.dart';

class DetailContactUsController extends GetxController {
  Rx<ContactUs?> contactUs = Rx<ContactUs?>(null);
  Rx<String?> pitchingDuration = Rx<String?>(null);

  final UserController userController = Get.find<UserController>();
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Future<void> fetchDetails(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/contact-us/show/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];
        pitchingDuration.value = rawData['pitching_duration'];
      }
    } catch (e) {
      rethrow;
    }
  }
}

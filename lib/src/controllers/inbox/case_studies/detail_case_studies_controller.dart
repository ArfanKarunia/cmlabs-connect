import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/case_studies_model.dart';
import '../../user/user_controller.dart';

class DetailCaseStudiesController extends GetxController {
  Rx<CaseStudies?> caseStudies = Rx<CaseStudies?>(null);
  Rx<String?> pitchingDuration = Rx<String?>(null);

  final UserController userController = Get.find<UserController>();
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Future<void> fetchDetails(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/case-studies/view-case-study-detail/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];
        caseStudies.value = caseStudies.value?.copyWith(
          data: caseStudies.value?.data?.copyWith(companyProfile: rawData['company_profile'] ?? '-'),
        );
        pitchingDuration.value = rawData['pitching_duration'];
      }
    } catch (e) {
      rethrow;
    }
  }
}

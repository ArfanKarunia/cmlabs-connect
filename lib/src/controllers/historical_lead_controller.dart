import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constant/config.dart';
import 'authentication_controller.dart';

class HistoricalLeadController extends GetxController{
  var data1 = Rx<List<Map<String,String>>>;
  var data2 = Rx<List<Map<String,String>>>;

  final AuthenticationController authenticationController = Get.put(AuthenticationController());
  final baseUrl = Config.baseURL;
  final Dio dio = Dio();

  Future<int> fetchNewLeadData() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        '$baseUrl/dashboard/historical_data_new',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

          // Kembalikan data yang di didapatkan dari API
          return responseData['data'] ?? 0;

      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return 0;
  }

}
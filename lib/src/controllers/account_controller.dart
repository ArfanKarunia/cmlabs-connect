import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:cmlabs_connect/src/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final UserController userController = Get.put(UserController());
  final baseUrl = Config.baseURL;
  final Dio dio = Dio();

  /* 
     ++ SUMMARY ++
  
  */

  final specializationList = [
    "Digial Marketing",
    "Web Developer",
    "SEO Writing",
    "UI/UX Designer",
  ];

  var about = Rx<String?>(null);
  var specialization = Rx<List<String?>>([]);
  var isChecked = List<bool>.filled(4, false).obs;

  Future<void> fetchSummary() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      // untuk Filter Status
      final response = await dio.get(
        '$baseUrl/profile/get-summary?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'];
        print(responseData);

        about.value = responseData['about'];
        var specList = List<String>.from(responseData['specialization']);
        specialization.value = specList;
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteSummary() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-summary?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        showSuccessToast("Success: Delete Summary");
      }else{
        showErrorToast("Failed: Delete Summary");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }
}

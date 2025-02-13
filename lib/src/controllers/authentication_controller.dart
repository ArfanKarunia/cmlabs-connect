import 'dart:convert';

import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../constant/config.dart';
import '../models/user_model.dart';
import '../routes.dart';
import '../utils/toast.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;
  var isRememberMe = false.obs;
  final roleList = Rx<List<Map<String, dynamic>>>([]);

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Box<Map>? loginBox;
  UserControler userController = Get.put(UserControler());

  @override
  void onInit() {
    super.onInit();
    loginBox = Hive.box<Map>('login'); // Inisialisasi Box remember me
  }

  Future<void> loadRememberedUser() async {
    try {
      isLoading(true);

      // Get remembered data
      final rememberedData = loginBox?.get('remember');
      if (rememberedData != null) {
        String email = rememberedData['email'];
        String password = rememberedData['password'];

        isRememberMe.value = true;

        await login(email, password);
      }
    } finally {
      isLoading(false);
    }
  }

  void saveRememberedLogin(String email, String password) {
    loginBox?.put('remember', {'email': email, 'password': password});
  }

  void clearRememberedLogin() {
    loginBox?.delete('remember');
  }

  void toggleRememberMe(bool value) {
    isRememberMe(value);
  }

  Future<Map<String, String>> login(String email, String password) async {
    isLoading(true);

    final apiUrl = "$baseUrl/auth/login";
    try {
      final response = await dio.post(
        apiUrl,
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      userController.accesToken.value = data['access_token'];
      userController.tokenType.value = data['token_type'];

      await fetchRoleList();

      var roles = roleList.value;

      var dataUser = data['data_user'];
      String? jobPosition = dataUser['job_position'];
      String? role = getRoleName(jobPosition, roles);

      if (role == null) {
        if (dataUser['role_name'] != null || dataUser['role_name'] != '') {
          userController.roleName.value = dataUser['role_name'];
        }
      } else {
        userController.roleName.value = role;
      }

      User user = User.fromMap(dataUser);

      userController.saveUser(user);
      userController.password.value = password;

      await storeDeviceToken(userController.deviceToken.value!, userController.user.value!.id.toString());

      if (isRememberMe.value) {
        saveRememberedLogin(email, password);
      } else {
        clearRememberedLogin();
      }

      Get.offAndToNamed(AppRoutes.home);

      return {
        "code": "400",
        "status": "Success",
        "message": "Login Berhasil, Selamat datang ${user.name}",
      };
    } on DioException catch (e) {
      String code = '500';
      String message = 'The selected email or password is invalid';

      if (e.response?.statusCode == 404) {
        code = '404';
        message = 'The email is invalid';
      } else if (e.response?.statusCode == 401) {
        code = '401';
        message = "The password is invalid.";
      } else if (e.response?.data != null) {
        message = e.response?.data['error'];
      }

      return {
        "code": code,
        "status": "Error",
        "message": message,
      };
    } finally {
      isLoading(false); // Pastikan untuk menonaktifkan loading
    }
  }

  Future<void> storeDeviceToken(String token, String userId) async {
    Dio dio = Dio();

    final apiUrl = "$baseUrl/notification/store_device_token";

    var requestData = {
      "token": token,
      "user_id": userId,
    };

    var body = jsonEncode(requestData);

    try {
      var response = await dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accesToken.value}',
            'Content-Type': 'application/json',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        print("Device Token berhasil di kirim");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      // Make the POST request
      print(baseUrl);
      print(userController.accesToken.value);
      var response = await dio.post(
        '$baseUrl/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer ${userController.accesToken.value}'}),
      );

      if (response.statusCode == 200) {
        clearRememberedLogin();

        showSuccessToast('Succses: Logout');
        Get.offAllNamed('/login');
        userController.user.value = null;
        userController.accesToken.value = '';
        userController.tokenType.value = '';
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    var requestData = {
      "id": userController.user.value?.id,
      "password_old": oldPassword,
      "password": newPassword,
      "password_confirmation": confirmPassword,
    };

    var body = jsonEncode(requestData);

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/profile/change-password'),
        headers: {
          'Authorization': 'Bearer ${userController.accesToken.value}',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Update new password");
        Get.back();
      } else {
        String errorMessage = "Failed to change password";

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  String? getRoleName(String? jobPositionId, List<Map<String, dynamic>> roles) {
    if (jobPositionId == null) {
      return null; // Default role if jobPositionId is null
    }

    // Find the role that matches the job position ID
    var matchedRole = roles.firstWhere(
      (role) => role['id'].toString() == jobPositionId,
      orElse: () => {}, // Return null if no match is found
    );

    // Return the role name if found, otherwise return 'User'
    return matchedRole != {} ? matchedRole['name'] : null;
  }

  Future<void> fetchRoleList() async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/position',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        // Simpan data specialization
        roleList.value = responseData
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  // User? getUser() {
  //   return userBox!.get('user'); // Ambil data user dari Hive
  // }

  // bool isLoggedIn() {
  //   return getUser() != null; // Cek apakah user sudah login
  // }
}

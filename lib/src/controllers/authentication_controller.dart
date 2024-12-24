import 'dart:convert';

import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../constant/config.dart';
import '../models/user_model.dart';
import '../utils/toast.dart';

class AuthenticationController extends GetxController {
  var accesToken = ''.obs;
  var tokenType = ''.obs;

  var isLoading = false.obs;
  var isRememberMe = false.obs;
  final roleList = Rx<List<Map<String, dynamic>>>([]);

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Box<Map>? loginBox;
  UserController userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    loginBox = Hive.box<Map>('login'); // Inisialisasi Box remember me
    loadRememberedUser();
  }

  Future<void> loadRememberedUser() async {
    try {
      isLoading(true);
      var rememberedData = loginBox?.get('remember');
      if (rememberedData != null) {
        String email = rememberedData['email'];
        String password = rememberedData['password'];
        print("Data Remember me");
        print(rememberedData);
        print("email: $email");
        print("password: $password");

        isRememberMe.value = true;

        await login(email, password);
      } else {
        print("Data Remember me");
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

  Future<Map<String, String>?> login(String email, String password) async {
    // isLoading.value = true;

    final apiUrl = baseUrl + "/auth/login";
    try {
      var response = await dio.post(
        apiUrl,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        var data = response.data;

        accesToken.value = data['access_token'];
        tokenType.value = data['token_type'];

        await fetchRoleList();

        var roles = roleList.value;

        String message = data['message'];

        var data_user = data['data_user'];
        String? jobPosition = data_user['job_position'];
        String? role = getRoleName(jobPosition, roles);

        if (role == null) {
          if (data_user['role_name'] != null || data_user['role_name'] != '') {
            userController.roleName.value = data_user['role_name'];
          }
        } else {
          userController.roleName.value = role;
        }

        User user = User.fromMap(data_user);

        userController.saveUser(user);
        userController.password.value = password;

        await storeDeviceToken(userController.deviceToken.value!,
            userController.user.value!.id.toString());

        if (isRememberMe.value) {
          saveRememberedLogin(email, password);
        } else {
          clearRememberedLogin();
        }

        Get.toNamed('/home');

        var feedback = {
          "status": 'Success',
          "message": 'Login Berhasil, Selamat datang ${user.name}',
        };

        return feedback;
      }
    } on DioException catch (e) {
      print("error: ${e.response}");

      // Default pesan error
      String message = 'The selected email or password is invalid';

      // Cek apakah response berisi data dan memiliki key 'error'
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        var errorData = e.response!.data as Map<String, dynamic>;
        if (errorData.containsKey('error')) {
          message = errorData['error']; // Ambil pesan dari key 'error'
        }
      }

      // Return feedback error
      var feedback = {
        "status": 'Error',
        "message": message,
      };

      return feedback;
    } finally {
      isLoading(false); // Pastikan untuk menonaktifkan loading
    }
    return null;
  }

  Future<void> storeDeviceToken(String token, String userId) async {
    Dio dio = Dio();

    final apiUrl = baseUrl + "/notification/store_device_token";

    var requestData = {
      "token": token,
      "user_id": userId,
    };

    var body = jsonEncode(requestData);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${accesToken.value}',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print("response code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Device Token berhasil di kirim");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      dio.options.headers = {
        'Authorization': 'Bearer ${accesToken.value}',
        'Content-Type': 'application/json',
      };

      // Make the POST request
      var response = await dio.post(
        '$baseUrl/auth/logout',
      );

      if (response.statusCode == 200) {
        userController.user.value = null;
        accesToken.value = '';
        tokenType.value = '';
        clearRememberedLogin();

        showSuccessToast('Succses: Logout}');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
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
          'Authorization': 'Bearer ${accesToken.value}',
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
      String? accessToken = accesToken.value;

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
      print('Error fetching status data: $e');
    }
  }

  // User? getUser() {
  //   return userBox!.get('user'); // Ambil data user dari Hive
  // }

  // bool isLoggedIn() {
  //   return getUser() != null; // Cek apakah user sudah login
  // }
}

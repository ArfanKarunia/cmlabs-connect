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

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Box<User>? userBox;
  UserController userController = Get.put(UserController());

  Future<Map<String, String>?> login(String email, String password) async {
    // isLoading.value = true;

    final apiUrl = baseUrl + "/auth/login";
    try {
      var response = await dio.post(
        apiUrl,
        data: {'email': email, 'password': password},
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        var data = response.data;

        String message = data['message'];
        User userData = User.fromMap(data['data_user']);

        userController.saveUser(userData);
        userController.password.value = password;

        accesToken.value = data['access_token'];
        tokenType.value = data['token_type'];

        showSuccessToast('$message, Selamat datang ${userData.name}');
        Get.toNamed('/home');

        var feedback = {
          "status": 'Success',
          "message": 'Login Berhasil, Selamat datang ${userData.name}',
        };

        return feedback;
      }
    } on DioException catch (e) {
      print(e.response);
      if (e.response != null) {
        print('Error Status Code: ${e.response!.statusCode}');

        var message = 'The selected email or password is invalid';

        // Pesan error yang sama untuk status 401 dan 500
        var feedback = {
          "status": 'Error',
          "message": message,
        };

        print("data error: $feedback");

        // Menangani status 401 dan 500
        if (e.response!.statusCode == 401 || e.response!.statusCode == 500) {
          return feedback;
        }
      } else {
        // Jika tidak ada response (misal masalah jaringan)
        var feedback = {
          "status": 'Error',
          "message": 'connection error occurred',
        };

        return feedback;
      }
    } finally {
      isLoading(false); // Pastikan untuk menonaktifkan loading
    }
    return null;
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

      print("Response data: ${response.statusCode}");
      print("Response data: ${response}");

      if (response.statusCode == 200) {
        userController.user.value = null;
        userController.userBox = null;
        userController.userBox = null;
        accesToken.value = '';
        tokenType.value = '';

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

    print(body);
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

  void toggleRememberMe(bool value) {
    isRememberMe(value);
  }

  User? getUser() {
    return userBox!.get('user'); // Ambil data user dari Hive
  }

  bool isLoggedIn() {
    return getUser() != null; // Cek apakah user sudah login
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:quotation_app/src/controllers/user_controller.dart';
import 'package:quotation_app/src/models/user_model.dart';
import 'package:quotation_app/src/utils/toast.dart';

class AuthenticationController extends GetxController {
  var accesToken = ''.obs;
  var tokenType = ''.obs;

  var isLoading = false.obs;
  var isRememberMe = false.obs;

  final Dio dio = Dio();
  final String apiLogin = 'https://api-connect.cmlabs.dev/auth/login';

  Box<User>? userBox;
  UserController userController = Get.put(UserController());

  Future<Map<String, String>?> login(String email, String password) async {
    // isLoading.value = true;
    try {
      var response = await dio.post(
        apiLogin,
        data: {'email': email, 'password': password},
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        var data = response.data;

        String message = data['message'];
        User userData = User.fromMap(data['data_user']);

        userController.saveUser(userData);

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
  }

  void toggleRememberMe(bool value) {
    isRememberMe(value);
  }

  Future<void> logout() async {
    userController.user.value = null; // Kosongkan state user
    accesToken.value = ''; // Reset akses token
    tokenType.value = ''; // Reset tipe token

    Get.snackbar('Success', 'Logged out successfully!');
  }

  User? getUser() {
    return userBox!.get('user'); // Ambil data user dari Hive
  }

  bool isLoggedIn() {
    return getUser() != null; // Cek apakah user sudah login
  }
}

import 'dart:convert';

import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../services/firebase_analytics_service.dart';
import '../../constant/config.dart';
import '../../models/user_model.dart';
import '../../routes.dart';
import '../../utils/toast.dart';

class AuthenticationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLogoutLoading = false.obs;
  RxBool isRememberMe = false.obs;
  final roleList = Rx<List<Map<String, dynamic>>>([]);

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final UserController userController = Get.find<UserController>();
  final FirebaseAnalyticsService analyticsService = Get.find<FirebaseAnalyticsService>();

  Future<void> setEmail(String email) async {
    await storage.write(key: 'email', value: email);
  }

  Future<String?> getEmail() async {
    return await storage.read(key: 'email');
  }

  Future<void> clearEmail() async {
    await storage.delete(key: 'email');
  }

  Future<void> setPassword(String password) async {
    await storage.write(key: 'password', value: password);
  }

  Future<String?> getPassword() async {
    return await storage.read(key: 'password');
  }

  Future<void> clearPassword() async {
    await storage.delete(key: 'password');
  }

  Future<void> loadRememberedUser() async {
    try {
      isLoading(true);

      final email = await getEmail();
      final password = await getPassword();

      if (email != null && password != null) await login(email, password);
    } finally {
      isLoading(false);
    }
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

      final roles = roleList.value;
      final dataUser = data['data_user'];
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

      await storeDeviceToken(
          userController.deviceToken.value ?? '', userController.user.value!.id.toString());

      if (isRememberMe.value) {
        await setEmail(email);
        await setPassword(password);
      }

      Get.offAndToNamed(AppRoutes.home);

      await analyticsService.logEvent(
        'login_success',
        parameters: {'name': user.name, 'email': email},
      );

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
      await dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accesToken.value}',
            'Content-Type': 'application/json',
          },
        ),
        data: body,
      );
    } catch (_) {}
  }

  Future<void> logout() async {
    if (isLogoutLoading.isTrue) return;

    try {
      isLogoutLoading(true);

      final response = await dio.post(
        '$baseUrl/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer ${userController.accesToken.value}'}),
      );

      if (response.statusCode == 200) {
        await clearEmail();
        await clearPassword();

        showSuccessToast('Success: Logout');
        Get.offAllNamed(AppRoutes.loginForm);
        userController.user.value = null;
        userController.accesToken.value = '';
        userController.tokenType.value = '';
      }
    } catch (_) {
      showErrorToast("Error: An unexpected error occurred.");
    } finally {
      Future.delayed(Durations.medium4, () {
        isLogoutLoading(false);
      });
    }
  }

  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    isLoading(true);
    try {
      final response = await dio.post(
        '$baseUrl/profile/change-password',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accesToken.value}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "id": userController.user.value?.id,
          "password_old": oldPassword,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        await setPassword(newPassword);
        showSuccessToast("Success: Update new password");
        Get.back();
      }
    } on DioException catch (e) {
      showErrorToast("Error: ${(e.response?.data['message'] ?? 'Failed to change password')}");
    } catch (_) {
      showErrorToast("Error: An unexpected error occurred.");
    } finally {
      isLoading(false);
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

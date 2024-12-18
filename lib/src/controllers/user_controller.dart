import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  var user = Rx<User?>(null);
  var deviceToken = Rx<String?>(null);
  var password = Rx<String?>(null);
  var roleName = "User".obs;

  Box<User>? userBox;

  final baseUrl = Config.baseURL;

  @override
  Future<void> onInit() async {
    super.onInit();

    // Buka box sebelum melakukan inisialisasi user
    userBox = await Hive.openBox<User>('userBox');

    // Ambil user setelah box terbuka
    user.value = getUser();
  }

  @override
  void dispose() {
    userBox?.close();

    super.dispose();
  }

  Future<void> saveUser(User newUser) async {
    user.value = newUser;
    // print("FCM Token: ${deviceToken.value}");

    // if (userBox != null) {
    //   await userBox!.put('user', newUser); // Simpan data dengan kunci 'user'

    //   print("Data User disimpan: ${user.value}");

    //   User? storedUser = userBox!.get('user'); // Ambil data dengan kunci 'user'
    //   print('Stored User setelah penyimpanan: $storedUser');
    // } else {
    //   print("UserBox belum diinisialisasi.");
    // }
  }

  User? getUser() {
    // Pastikan box sudah diinisialisasi
    if (userBox != null) {
      return userBox!.get('user'); // Ambil data dengan kunci 'user'
    }
    return null;
  }
}

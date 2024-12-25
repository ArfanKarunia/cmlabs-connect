import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class UserControler extends GetxController {
  var accesToken = Rx<String?>(null);
  var tokenType = Rx<String?>(null);

  var user = Rx<User?>(null);
  var deviceToken = Rx<String?>(null);
  var password = Rx<String?>(null);
  var roleName = "User".obs;

  final baseUrl = Config.baseURL;

  Future<void> saveUser(User newUser) async {
    user.value = newUser;
    user.refresh();
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
}

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quotation_app/src/models/user_model.dart';

class UserController extends GetxController{
  
  var user = Rx<User?>(null);
  
  Box<User>? userBox;

  @override
  void onInit() {
    super.onInit();

    user.value = getUser(); 
  }

  User? getUser() {
    // Pastikan box sudah diinisialisasi
    if (userBox != null) {
      return userBox!.get('user');
    }
    return null;
  }

  Future<void> saveUser(User newUser) async {
    await userBox!.put('user', newUser); 
    user.value = newUser;
  }

  Future<void> clearUser() async {
    await userBox!.delete('user'); 
    user.value = null;
  }

  bool isLoggedIn() {
    return user.value != null; 
  }

}
import 'dart:math';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UrlTrackingController extends GetxController {
  var search = Rx<String?>(null);
  var validityDurationList = <Map<String, String>>[].obs;

  var isTracking = false.obs;

  final TextEditingController urlController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  var selectedValidity = Rx<Map<String, String>?>(null);

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final baseUrl = Config.baseURL;

  final Dio dio = Dio();



  void changeStatusTracking(int id, value) {
    isTracking.value = value;
    fetchUrl(id);
    fetchValidity();
  }

  void generatePassword() {
    String newPassword = generateRandomPassword();
    passwordController.text = newPassword;
  }

  Future<void> fetchUrl(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // get Data PIC
      final response = await dio.get(
        '$baseUrl/quotation/generate_url_tracker?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'];

        urlController.text = responseData;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchValidity() async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // get Data PIC
      final response = await dio.get(
        '$baseUrl/quotation/list_validity',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'];

        var mappedData = responseData.map<Map<String, String>>((status) {
          return {
            'value': status['value']?.toString() ?? '',
            'label': status['label']?.toString() ?? '',
          };
        }).toList();

        validityDurationList.assignAll(mappedData);
      }

      // Untuk Filter Client Source
    } catch (e) {
      print(e);
    }
  }

  void addValidity(Map<String, String> data) {
    selectedValidity.value = data;
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: ${select}");
    print("Current Search Query: ${search.value}");

    result = validityDurationList;

    // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
    if (search.value != null && search.value!.isNotEmpty) {
      final query = search.value!.toLowerCase();
      result = result.where((type) {
        // print("Checking status: ${status['value']} - ${status['label']}");
        return type['value'].toLowerCase().contains(query) ||
            type['label'].toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  String generateRandomPassword({
    int length = 12,
    bool includeUppercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    const String lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_+[]{}<>?,.';

    // Membuat kumpulan karakter yang akan digunakan
    String characters = lowercaseLetters;
    if (includeUppercase) characters += uppercaseLetters;
    if (includeNumbers) characters += numbers;
    if (includeSymbols) characters += symbols;

    // Acak dan buat kata sandi
    Random random = Random();
    String password = List.generate(length, (index) {
      return characters[random.nextInt(characters.length)];
    }).join();

    return password;
  }
}

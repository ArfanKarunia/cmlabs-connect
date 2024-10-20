import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quotation_app/src/constant/config.dart';
import 'package:quotation_app/src/controllers/authentication_controller.dart';
import 'package:quotation_app/src/models/client_pic_model.dart';
import 'package:quotation_app/src/models/client_source_model.dart';

class PicController extends GetxController {
  var listPic = <ClientPic>[].obs;

  Box<ClientPic>? picBox;

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final dio = Dio();
  final baseUrl = Config.baseURL;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Membuka box untuk menyimpan data dashboard
    picBox = await Hive.openBox<ClientPic>('picBox');
    await loadSavedData();
  }

  @override
  void dispose() {
    picBox?.close();
    super.dispose();
  }

  Future<void> loadSavedData() async {
    if (picBox != null) {
      listPic.value = picBox!.values.toList();
    }
  }

  Future<void> fetchNewPICData({bool isLoadMore = false}) async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        '$baseUrl/filter/pic',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        print(responseData);

        if (responseData['status'] == 'success') {
          List<ClientPic> tmpPic = [];

          // Cek apakah data pic ada di response
          if (responseData['data'] is List) {
            for (var picData in responseData['data']) {
              tmpPic.add(ClientPic.fromJson(
                  picData)); // Asumsikan ada ClientPic.fromJson
            }
          } else {
            print("Data PIC tidak berupa list.");
          }

          // Update listPic dengan data baru
          if (isLoadMore) {
            listPic.addAll(tmpPic); // Menambah data baru jika isLoadMore
          } else {
            listPic.value = tmpPic; // Reset listPic dengan data baru
          }

          // Cek dan simpan data baru ke Hive jika belum ada
          // for (var newPic in tmpPic) {
          //   if (!listPic.any((existingPic) => existingPic.name!.toLowerCase() == newPic.name!.toLowerCase())) {
          //     // Simpan ke Hive jika menggunakan Hive
          //     // await picBox!.add(newPic); // Uncomment jika Anda ingin menyimpan ke Hive
          //     listPic.add(newPic); // Menambah ke listPic
          //   }
          // }

          print("Berhasil mengambil data LIST PIC dari API");
          for (var pic in listPic) {
            print(pic.name);
          }
        } else {
          print("Status API tidak 'success'.");
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

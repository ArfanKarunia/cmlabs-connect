import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/controllers/authentication_controller.dart';
import 'package:quotation_app/src/models/client_source_model.dart';

class ClientSourceController extends GetxController {
  Dio dio = Dio();

  List<ClientSource> listSource = [
    ClientSource(id: 1, name: 'Direct Email'),
    ClientSource(id: 2, name: 'Web WhatsApp'),
    ClientSource(id: 3, name: 'Direct Linkedin'),
    ClientSource(id: 4, name: 'Direct Call'),
    ClientSource(id: 5, name: 'Referral'),
  ];

  String accessToken = AuthenticationController().accesToken.value;

  List<ClientSource> get getListClientSource {
    return listSource;
  }

  // Future<void> fetchClientSourceData() async {
  //   // String baseUrl = dotenv.env["BASE_URL"] ?? '';
  //   final apiURL = baseUrl + "/filter/client_source";

  //   print(apiURL);
  //   print(accessToken);

  //   try {
  //     final response = await dio.get(
  //       apiURL,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $accessToken',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       print(response.data);
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
}

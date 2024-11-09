import 'package:cmlabs_connect/src/models/historical_lead_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constant/config.dart';
import 'authentication_controller.dart';

class HistoricalLeadController extends GetxController {
  var search = Rx<String?>(null);

  final year1 = Rx<String?>(null);
  final year2 = Rx<String?>(null);

  final month1 = Rx<String?>(null);
  final month2 = Rx<String?>(null);

  final historicalData1 = Rx<HistoricalLeadModel?>(null);
  final historicalData2 = Rx<HistoricalLeadModel?>(null);

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final baseUrl = Config.baseURL;
  final Dio dio = Dio();

  bool isDatePairFilled() {
    return (year1.value != null && month1.value != null) ||
        (year2.value != null && month2.value != null);
  }

  void submit() async {
    if (year1.value != null && month1.value != null) {
      await fetchHistoricalData(1);
    }

    if (year2.value != null && month2.value != null) {
      await fetchHistoricalData(2);
    }
  }

  Future<void> fetchHistoricalData(int index) async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        '$baseUrl/dashboard/historical_data_new',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;
        var historicalData = HistoricalLeadModel.fromJson(responseData);

        if (index == 1) {
          historicalData1.value = historicalData;
        } else if (index == 2) {
          historicalData2.value = historicalData;
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: ${select}");
    print("Current Search Query: ${search.value}");

    if (select == 'year') {
      result = yearList;

      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((data) {
          return data.toLowerCase().contains(query);
        }).toList();
      }
    }

    if (select == 'month') {
      result = monthList;

      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((data) {
          return data.toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  void clear() {
    year1.value = null;
    year2.value = null;
    month1.value = null;
    month2.value = null;
  }

  final yearList = [
    "2024",
    "2023",
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
  ];

  final monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "Desember",
  ];
}

import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:cmlabs_connect/src/models/historical_lead_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constant/config.dart';

class HistoricalLeadController extends GetxController {
  var search = Rx<String?>(null);

  final year1 = Rx<String?>(null);
  final year2 = Rx<String?>(null);

  final month1 = Rx<String?>(null);
  final month2 = Rx<String?>(null);

  final historicalData1 = Rx<HistoricalLeadModel?>(null);
  final historicalData2 = Rx<HistoricalLeadModel?>(null);

  final UserControler userControler = Get.put(UserControler());

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
      String? accessToken = userControler.accesToken.value;

      var data = requestData(index);

      // Ambil data dari API
      final response = await dio.get('$baseUrl/dashboard/historical_data_new',
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: data);

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;
        var historicalData = HistoricalLeadModel.fromJson(responseData['data']);

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

  Future<void> fetchList(String filter) async {
    try {} catch (e) {
      print('Error fetching status data: $e');
    }
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: $select");
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
    historicalData1.value = null;
    historicalData2.value = null;
    year1.value = null;
    year2.value = null;
    month1.value = null;
    month2.value = null;
  }

  Map<String, dynamic> requestData(int index) {
    String monthString = index == 1 ? month1.value ?? '' : month2.value ?? '';

    int monthInt = convertMonthToInt(monthString);
    
    Map<String, dynamic> requestData = {
      "year": index == 1 ? year1.value : year2.value,
      "month": monthInt,
    };

    return requestData;
  }

  int convertMonthToInt(String month) {
    int index = monthList.indexOf(month);

    return index != -1 ? index + 1 : 0;
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

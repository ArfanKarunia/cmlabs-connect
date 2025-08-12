import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:cmlabs_connect/src/models/historical_lead_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../constant/config.dart';

class HistoricalLeadController extends GetxController {
  Rx<Map<String, String>?> year1 = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> month1 = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> year2 = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> month2 = Rx<Map<String, String>?>(null);

  Rx<HistoricalLeadModel?> historicalData1 = Rx<HistoricalLeadModel?>(null);
  Rx<HistoricalLeadModel?> historicalData2 = Rx<HistoricalLeadModel?>(null);

  Rx<bool> isLoading = false.obs;

  Rx<String?> year1Error = Rx<String?>(null);
  Rx<String?> month1Error = Rx<String?>(null);
  Rx<String?> year2Error = Rx<String?>(null);
  Rx<String?> month2Error = Rx<String?>(null);

  final UserController userController = Get.find<UserController>();

  final baseUrl = Config.baseURL;
  final Dio dio = Dio();

  bool isDatePairFilled() {
    return (year1.value != null && month1.value != null) || (year2.value != null && month2.value != null);
  }

  void submit() async {
    isLoading(true);

    if (year1.value != null && month1.value != null) {
      await fetchHistoricalData(1);
    }

    if (year2.value != null && month2.value != null) {
      await fetchHistoricalData(2);
    }

    isLoading(false);
  }

  Future<void> fetchHistoricalData(int index) async {
    try {
      String? accessToken = userController.accesToken.value;

      final body = requestData(index);
      final response = await dio.get(
        '$baseUrl/dashboard/historical_data_new',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: body,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final historicalData = HistoricalLeadModel.fromJson(data['data']);

        if (index == 1) {
          historicalData1.value = historicalData;
        } else if (index == 2) {
          historicalData2.value = historicalData;
        }
      }
    } on DioException catch (_) {} catch (_) {}
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
    String monthData = '';
    String yearData = '';

    if (month1.value != null || month2.value != null) {
      monthData = index == 1 ? month1.value!['value'] ?? '' : month2.value!['value'] ?? '';
    }

    if (year1.value != null || year2.value != null) {
      yearData = index == 1 ? year1.value!['value'] ?? '' : year2.value!['value'] ?? '';
    }

    Map<String, dynamic> requestData = {
      "year": yearData,
      "month": monthData,
    };

    return requestData;
  }

  final yearList = List.generate(
    10,
    (index) {
      final currentYear = DateTime.now().year;
      return {
        "value": "${currentYear - index}",
        "label": "${currentYear - index}",
      };
    },
  );

  final monthList = List.generate(
    12,
    (index) => {
      "value": "${index + 1}",
      "label": [
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
        "December"
      ][index],
    },
  );

  List<Map<String, String>> getData(HistoricalLeadSelectType type) {
    switch (type) {
      case HistoricalLeadSelectType.year:
        return yearList;
      case HistoricalLeadSelectType.month:
        return monthList;
    }
  }

  void setValue({
    required HistoricalLeadSelectType data,
    required int index,
    required Map<String, String> value,
  }) {
    switch (data) {
      case HistoricalLeadSelectType.year:
        if (index == 1) {
          year1.value = value;
        } else if (index == 2) {
          year2.value = value;
        }
        break;
      case HistoricalLeadSelectType.month:
        if (index == 1) {
          month1.value = value;
        } else if (index == 2) {
          month2.value = value;
        }
        break;
    }
  }
}

enum HistoricalLeadSelectType { year, month }

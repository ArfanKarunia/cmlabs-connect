import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class GeneralInfoController extends GetxController {
  var search = Rx<String?>(null);

  final AuthenticationController authenticationController = Get.put(AuthenticationController());
  final UserControler userControler = Get.put(UserControler());

  final baseUrl = Config.baseURL;
  final dio = Dio();

  /*

    GENERAL DATA

    - single pic
    - single priority
    - single status
    - multiple type leads

  */

  var selectPic = Rx<Map<String, String>?>(null);
  var selectPriority = Rx<Map<String, String>?>(null);
  var selectStatus = Rx<Map<String, String>?>(null);
  var selectType = Rx<Map<String, String>?>(null);

  var picList = <Map<String, String>>[].obs;
  var priorityList = <Map<String, String>>[].obs;
  var statusList = <Map<String, String>>[].obs;
  var typeList = <Map<String, String>>[].obs;

  Future<void> loadData(String? pic, int priority, int status, List<String?> type) async {
    print("data pic: $pic");
    print("data priority: $priority");
    print("data status: $status");
    print("data type: $type'}");

    // Mencocokkan dan menyimpan data priority ke selectPriority
    selectPriority.value = priorityList.firstWhere(
      (element) => element['value'] == priority.toString(),
      orElse: () => <String, String>{},
    );

    // Mencocokkan dan menyimpan data status ke selectStatus
    selectStatus.value = statusList.firstWhere(
      (element) => element['value'] == status.toString(),
      orElse: () => <String, String>{},
    );

    if (pic != null) {
      selectPic.value = picList.firstWhere(
        (element) => element['value'] == pic,
        orElse: () => <String, String>{},
      );
    }

    // Mencocokkan dan menyimpan data type ke selectType
    if (type.isNotEmpty) {
      selectType.value = {'value': type[0]!, 'label': type[0]!};
    }

    // editQuotationController.onFieldChanged();
  }

  void clearSelectedData() {
    print("Clear selected data");
    selectPic.value = null;
    selectPriority.value = null;
    selectStatus.value = null;
    selectType.value = null;

    print("selectPic: ${selectPic.value}");
    print("selectPriority: ${selectPriority.value}");
    print("selectStatus: ${selectStatus.value}");
    print("selectType: ${selectType.value}");
  }

  // ADD & DELETE PIC
  void addPIC(Map<String, String> pic) {
    selectPic.value = pic;
  }

  void deletePIC(Map<String, String> pic) {
    selectPic.value = null;
  }

  // ADD & DELETE PRIORITY
  void addPriority(Map<String, String> priority) {
    selectPriority.value = priority;
  }

  // ADD & DELETE STATUS
  void addStatus(Map<String, String> status) {
    selectStatus.value = status;
    updateTypeList(status['value'] ?? '');
  }

  // ADD & DELETE TYPE
  void addType(Map<String, String> type) {
    selectType.value = type;
  }

  void deleteType(Map<String, String> type) {
    selectType.value = null;
  }

  void updateTypeList(String statusValue) {
    typeList.value = typeOptions[statusValue] ?? [];
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: $select");
    print("Current Search Query: ${search.value}");

    if (select.toLowerCase() == 'pic') {
      result = picList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((pic) {
          return pic['value'].toLowerCase().contains(query) ||
              pic['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    if (select.toLowerCase() == 'priority') {
      result = priorityList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((priority) {
          return priority['value'].toLowerCase().contains(query) ||
              priority['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    if (select.toLowerCase() == 'status') {
      result = statusList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((status) {
          return status['value'].toLowerCase().contains(query) ||
              status['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    if (select.toLowerCase() == 'type') {
      result = typeList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((type) {
          return type['value'].toLowerCase().contains(query) ||
              type['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  Future<void> fetchList(String search) async {
    try {
      String? accessToken = userControler.accesToken.value;

      // get Data PIC
      if (search.toLowerCase() == "pic") {
        final response = await dio.get(
          '$baseUrl/filter/pic',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          var responseData = response.data['data'];

          var mappedData = responseData.map<Map<String, String>>((pic) {
            return {
              'value': pic['value']?.toString() ?? '',
              'label': pic['label']?.toString() ?? '',
            };
          }).toList();

          picList.assignAll(mappedData);
        }

        // get Data Priority
      } else if (search.toLowerCase() == "priority") {
        final response = await dio.get(
          '$baseUrl/quotation/list_priority',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          var responseData = response.data['data'];

          var mappedData = responseData.map<Map<String, String>>((priority) {
            return {
              'value': priority['value']?.toString() ?? '',
              'label': priority['label']?.toString() ?? '',
            };
          }).toList();

          priorityList.assignAll(mappedData);
        }

        // get Data Status
      } else if (search.toLowerCase() == "status") {
        final response = await dio.get(
          '$baseUrl/quotation/list_status',
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

          statusList.assignAll(mappedData);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  final typeOptions = {
    "0": <Map<String, String>>[], // New - tidak ada type
    "1": [
      {"value": "Email", "label": "Email"},
      {"value": "WhatsApp", "label": "WhatsApp"},
      {"value": "Linkedin", "label": "Linkedin"},
    ], // Followed Up
    "2": [
      {"value": "Meeting Required", "label": "Meeting Required"},
      {"value": "Meeting Done", "label": "Meeting Done"},
      {"value": "QL Sent", "label": "QL Sent"},
      {"value": "Follow Up QL", "label": "Follow Up QL"},
    ], // Accepted
    "3": [
      {"value": "Price", "label": "Price"},
      {"value": "Ghosting", "label": "Ghosting"},
      {"value": "Email Invalid", "label": "Email Invalid"},
      {"value": "No response via Email", "label": "No response via Email"},
      {
        "value": "No response via WhatsApp",
        "label": "No response via WhatsApp"
      },
      {"value": "Need another service", "label": "Need another service"},
      {"value": "WhatsApp Invalid", "label": "WhatsApp Invalid"},
    ], // Rejected/
    "4": <Map<String, String>>[], // on Hold - tidak ada type
  };
}

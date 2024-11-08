import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailQuotationController extends GetxController {
  var isShowAll = false.obs;
  var search = Rx<String?>(null);

  // simpan sementara data perubahan
  var selectPic = Rx<Map<String, String>?>(null);
  var selectPriority = Rx<Map<String, String>?>(null);
  var selectStatus = Rx<Map<String, String>?>(null);
  var selectedType = Rx<Map<String, String>?>(null);

  final RxList<ClientPic> selectedPICClient = [
    ClientPic(name: '', position: '', contacts: []),
  ].obs;

  List<TextEditingController> nameControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> positionControllers = [
    TextEditingController(),
  ];

  // Memastikan jumlah controller sesuai dengan jumlah data
  void syncClientPIC() {
    nameControllers = selectedPICClient
        .map((pic) => TextEditingController(text: pic.name))
        .toList();
    positionControllers = selectedPICClient
        .map((pic) => TextEditingController(text: pic.position))
        .toList();
  }

  var isAvailableToUser = false.obs;

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final baseUrl = Config.baseURL;
  final dio = Dio();

  var picList = <Map<String, String>>[].obs;
  var priorityList = <Map<String, String>>[].obs;
  var statusList = <Map<String, String>>[].obs;
  var typeList = <Map<String, String>>[].obs;

  final typeOptions = {
    "0": <Map<String, String>>[], // New - tidak ada type
    "1": [
      {"value": "email", "label": "Email"},
      {"value": "whatsapp", "label": "WhatsApp"},
      {"value": "linkedin", "label": "Linkedin"},
    ], // Followed Up
    "2": [
      {"value": "meeting_required", "label": "Meeting Required"},
      {"value": "meeting_done", "label": "Meeting Done"},
      {"value": "ql_sent", "label": "QL Sent"},
      {"value": "follow_up_ql", "label": "Follow Up QL"},
    ], // Accepted
    "3": [
      {"value": "price", "label": "Price"},
      {"value": "ghosting", "label": "Ghosting"},
      {"value": "email_invalid", "label": "Email Invalid"},
      {"value": "no_response_email", "label": "No response via Email"},
      {"value": "no_response_whatsapp", "label": "No response via WhatsApp"},
      {"value": "need_another_service", "label": "Need another service"},
      {"value": "whatsapp_invalid", "label": "WhatsApp Invalid"},
    ], // Rejected/
    "4": <Map<String, String>>[], // on Hold - tidak ada type
  };

  final title = [
    "ID",
    "Joined at",
    "Status",
    "Category",
    "Client Source",
    "Name",
    "Email",
    "Whatsapp",
    "Company Website",
    "Company Profile",
    "Page Source",
    "Service",
    "Region",
    "Pitching Duration",
  ];

  @override
  void onInit() async {
    super.onInit();
    await fetchList("pic");
    await fetchList("priority");
    await fetchList("status");
    print("banyak client pic : ${selectedPICClient.length}");
    print("banyak contact client pic 1 : ${selectedPICClient[0].contacts.length}");
  }

  void clearSelectedData() {
    selectPic.value = null;
    selectPriority.value = null;
    selectStatus.value = null;
    selectedType.value = null;

    // print("data pic: ${selectPic.value}");
    // print("data priority: ${selectPriority.value}");
    // print("data status: ${selectStatus.value}");
  }

  void changeShowValue() {
    isShowAll.value = !isShowAll.value;
  }

  bool get getShowAllValue {
    return isShowAll.value;
  }

  // ADD & DELETE PIC
  void addPIC(Map<String, String> pic) {
    selectPic.value = pic;
  }

  void deletePIC(Map<String, String> pic) {
    selectPic.value = {};
  }

  // ADD & DELETE PRIORITY
  void addPriority(Map<String, String> priority) {
    selectPriority.value = priority;
  }

  void deletePriority(Map<String, String> priority) {
    selectPriority.value = {};
  }

  // ADD & DELETE STATUS
  void addStatus(Map<String, String> status) {
    selectStatus.value = status;
    updateTypeList(status['value'] ?? '');
  }

  void deleteStatus(Map<String, String> status) {
    selectStatus.value = {};
    typeList.clear();
  }

  // ADD & DELETE PRIORITY
  void addType(Map<String, String> type) {
    selectedType.value = type;
  }

  void deleteType(Map<String, String> type) {
    selectedType.value = {};
  }

  void updateTypeList(String statusValue) {
    typeList.value = typeOptions[statusValue] ?? [];
  }

  // CLient PIC
  void addPICClient() {
    selectedPICClient.add(ClientPic(name: '', position: '', contacts: []));
    nameControllers.add(TextEditingController());
    positionControllers.add(TextEditingController());
    syncClientPIC();
  }

  void removePICClient(int index) {
    selectedPICClient.removeAt(index);
    nameControllers.removeAt(index);
    positionControllers.removeAt(index);
    syncClientPIC();
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: ${select}");
    print("Current Search Query: ${search.value}");

    if (select.toLowerCase() == 'pic') {
      result = picList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((pic) {
          // print("Checking status: ${status['value']} - ${status['label']}");
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
          // print("Checking status: ${status['value']} - ${status['label']}");
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
          // print("Checking status: ${status['value']} - ${status['label']}");
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
          // print("Checking status: ${status['value']} - ${status['label']}");
          return type['value'].toLowerCase().contains(query) ||
              type['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  void editSelectedData(Quotation quotation) {
    if (quotation.data.pic != null && quotation.data.pic != "") {
      // Mencari item dalam picList yang memiliki value sesuai dengan quotation.data.pic
      final matchedPic = picList.firstWhere(
        (pic) => pic['value'] == quotation.data.pic,
        orElse: () =>
            <String, String>{}, // Mengembalikan Map kosong jika tidak ditemukan
      );

      // Menyimpan matchedPic ke dalam selectPic jika ditemukan, atau null jika tidak ada kecocokan
      selectPic.value = matchedPic.isNotEmpty ? matchedPic : null;
    }

    // SET Select data Priority
    final matchedPriority = priorityList.firstWhere(
      (priority) => priority['value'] == quotation.priority.toString(),
      orElse: () =>
          <String, String>{}, // Mengembalikan Map kosong jika tidak ditemukan
    );

    // Menyimpan matchedPic ke dalam selectPic jika ditemukan, atau null jika tidak ada kecocokan
    selectPriority.value = matchedPriority.isNotEmpty ? matchedPriority : null;

    // SET Select data Status
    final matchedStatus = statusList.firstWhere(
      (status) => status['value'] == quotation.status.toString(),
      orElse: () =>
          <String, String>{}, // Mengembalikan Map kosong jika tidak ditemukan
    );

    // Menyimpan matchedPic ke dalam selectPic jika ditemukan, atau null jika tidak ada kecocokan
    selectStatus.value = matchedStatus.isNotEmpty ? matchedStatus : null;
  }

  Map<String, String> detailData(Quotation quotation) {
    return {
      "company": quotation.data.company ?? "Nama Perusahaan",
      "ID": quotation.id.toString(),
      "Joined at": quotation.createdAt.toString(),
      "Status": labelStatusLead(quotation.status),
      "Category": quotation.data.category.join(', '),
      "Client Source": quotation.data.clientSource?.name ?? "-",
      "Name": quotation.data.company ?? "-",
      "Email": quotation.email,
      "Whatsapp": quotation.data.phoneNumber ?? "-",
      "Company Website": quotation.data.website ?? "-",
      "Company Profile": quotation.data.companyIndustry ?? "-",
      "Page Source": quotation.url,
      "Service": quotation.section ?? "-",
      "Region": quotation.data.region ?? "-",
      "Pitching Duration": "??"
    };
  }

  Future<void> fetchList(String search) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

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

  String labelStatusLead(int status) {
    var label = '';
    switch (status) {
      case 0:
        label = "New";
        break;
      case 1:
        label = "Followed Up";
        break;
      case 2:
        label = "Accepted";
        break;
      case 3:
        label = "Rejected";
        break;
      case 4:
        label = "On hold";
        break;
      default:
        label = "New";
    }

    return label;
  }
}

import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:get/get.dart';

class ContactpicController extends GetxController {
  var search = Rx<String?>(null);

  final selectedContactType = Rx<Map<String, String>?>(null);
  final selectedContactStatus = Rx<Map<String, String>?>(null);
  final selectedDetailStatus = Rx<Map<String, String>?>(null);

  var info = Rx<String?>(null);
  var note = Rx<String?>(null);

  var statusList = <Map<String, String>>[].obs;
  var detailStatusList = <Map<String, String>>[].obs;

  void addType(Map<String, String> type) {
    selectedContactType.value = type;
    updateTypeStatus(type['value'] ?? '');
  }

  // Status Contact LIST
  void addStatus(Map<String, String> status) {
    selectedContactStatus.value = status;
    updateDetailStatus(status["value"] ?? '');
  }

  void updateTypeStatus(String typeValue) {
    statusList.value = statusContact[typeValue] ?? [];
  }

  // Detail Status Contact LIST
  void addDetailStatus(Map<String, String> status) {
    selectedDetailStatus.value = status;
  }

  void updateDetailStatus(String statusValue) {
    detailStatusList.value = detailStatusContact[statusValue] ?? [];
  }

  void addInfo(String value) {
    info.value = value;
  }

  void addNote(String value) {
    note.value = value;
  }

  void clearData(){
    selectedContactStatus.value = null;
    selectedContactType.value = null;
    selectedDetailStatus.value = null;
    info.value = null;
    note.value = null;
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: $select");
    print("Current Search Query: ${search.value}");

    if (select.toLowerCase() == 'type_contact') {
      result = typeContact;

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

    if (select.toLowerCase() == 'status_contact') {
      result = statusList;

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

    if (select.toLowerCase() == 'detail_contact') {
      result = detailStatusList;

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

  final typeContact = [
    {"value": "Email", "label": "Email"},
    {"value": "Whatsapp", "label": "Whatsapp"},
    {"value": "Phone Number", "label": "Phone Number"},
    {"value": "Telegram", "label": "Telegram"},
    {"value": "LinkedIn", "label": "LinkedIn"},
    {"value": "Direct Visit", "label": "Direct Visit"},
  ];

  final statusContact = {
    "Email": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
    ],
    "Whatsapp": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
    ],
    "Phone Number": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
    ],
    "Telegram": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
    ],
    "LinkedIn": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
    ],
    "Direct Visit": [
      {"value": "Visited", "label": "Visited"},
      {"value": "Not Visited", "label": "Not Visited"},
    ],
  };

  Map<String, List<Map<String, String>>> detailStatusContact = {
    "Contacted": [
      {"value": "Unreachable", "label": "Unreachable"},
      {"value": "No further response", "label": "No further response"},
    ],
    "Not Contacted": [],
    "Visited": [
      {"value": "Met PIC", "label": "Met PIC"},
      {"value": "Failed met PIC", "label": "Failed met PIC"},
    ],
    "Not Visited": [],
  };

  ContactClientPic createContactPIC(String? info, String? note) {
    ContactClientPic contactClientPic = ContactClientPic(
      type: selectedContactType.value?['value'],
      info: info,
      status: selectedContactStatus.value?['value'],
      detail: selectedDetailStatus.value?['value'],
      note: note,
    );
    clearData();
    return contactClientPic;
  }
}

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

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: ${select}");
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
    {"value": "email", "label": "Email"},
    {"value": "whatsapp", "label": "Whatsapp"},
    {"value": "phone_number", "label": "Phone Number"},
    {"value": "telegram", "label": "Telegram"},
    {"value": "linkedin", "label": "LinkedIn"},
    {"value": "direct_visit", "label": "Direct Visit"},
  ];

  final statusContact = {
    "email": [
      {"value": "contacted", "label": "Contacted"},
      {"value": "not_contacted", "label": "Not Contacted"},
    ],
    "whatsapp": [
      {"value": "contacted", "label": "Contacted"},
      {"value": "not_contacted", "label": "Not Contacted"},
    ],
    "phone_number": [
      {"value": "contacted", "label": "Contacted"},
      {"value": "not_contacted", "label": "Not Contacted"},
    ],
    "telegram": [
      {"value": "contacted", "label": "Contacted"},
      {"value": "not_contacted", "label": "Not Contacted"},
    ],
    "linkedin": [
      {"value": "contacted", "label": "Contacted"},
      {"value": "not_contacted", "label": "Not Contacted"},
    ],
    "direct_visit": [
      {"value": "visited", "label": "Visited"},
      {"value": "not_visited", "label": "Not Visited"},
    ],
  };

  Map<String, List<Map<String, String>>> detailStatusContact = {
    "contacted": [
      {"value": "unreachable", "label": "Unreachable"},
      {"value": "no_futher_response", "label": "No further response"},
    ],
    "not_contacted": [],
    "visited": [
      {"value": "met_pic", "label": "Met PIC"},
      {"value": "failed_met_pic", "label": "Failed met PIC"},
    ],
    "not_visited": [],
  };

  ContactClientPic createContactPIC(String? info, String? note) {
    ContactClientPic contactClientPic = ContactClientPic(
      type: selectedContactType.value?['value'],
      info: info,
      status: selectedContactStatus.value?['value'],
      detail: selectedDetailStatus.value?['value'],
      note: note,
    );
    return contactClientPic;
  }
}

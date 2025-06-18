import 'package:cmlabs_connect/src/models/inbox/property/client_pic_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientPicContactController extends GetxController {
  var search = Rx<String?>(null);

  Rx<Map<String, String>?> selectedContactType = Rx<Map<String, String>?>(null);
  Rx<TextEditingController> contactInfo = TextEditingController().obs;
  Rx<Map<String, String>?> selectedContactStatus = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> selectedContactDetailStatus = Rx<Map<String, String>?>(null);
  Rx<TextEditingController> contactNote = TextEditingController().obs;

  RxList<Map<String, String>> statusList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> detailStatusList = <Map<String, String>>[].obs;

  // Error Text
  Rx<String?> contactTypeError = Rx<String?>(null);
  Rx<String?> contactInfoError = Rx<String?>(null);
  Rx<String?> contactStatusError = Rx<String?>(null);
  Rx<String?> contactDetailStatusError = Rx<String?>(null);

  @override
  void dispose() {
    contactInfo.value.dispose();
    contactNote.value.dispose();
    super.dispose();
  }

  bool validateForm() {
    contactTypeError.value = selectedContactType.value == null ? 'The Contact Type must not be empty.' : null;
    contactStatusError.value = selectedContactStatus.value == null ? 'The Contact Status must not be empty.' : null;
    contactDetailStatusError.value =
        selectedContactDetailStatus.value == null ? 'The Detail Status must not be empty.' : null;
    contactInfoError.value = contactInfo.value.text.isEmpty ? 'The Contact Info must not be empty.' : null;

    return contactTypeError.value == null &&
        contactStatusError.value == null &&
        contactDetailStatusError.value == null &&
        contactInfoError.value == null;
  }

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
    statusList.value = contactStatus[typeValue] ?? [];
  }

  // Detail Status Contact LIST
  void addDetailStatus(Map<String, String> status) {
    selectedContactDetailStatus.value = status;
  }

  void updateDetailStatus(String statusValue) {
    detailStatusList.value = contactDetailStatus[statusValue] ?? [];
  }

  void addInfo(String value) {
    contactInfo.value.text = value;
  }

  void addNote(String value) {
    contactNote.value.text = value;
  }

  void clearData() {
    selectedContactStatus.value = null;
    selectedContactType.value = null;
    selectedContactDetailStatus.value = null;
    contactInfo.value.text = '';
    contactNote.value.text = '';
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
      result = contactType;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((type) {
          // print("Checking status: ${status['value']} - ${status['label']}");
          return type['value'].toLowerCase().contains(query) || type['label'].toLowerCase().contains(query);
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
          return type['value'].toLowerCase().contains(query) || type['label'].toLowerCase().contains(query);
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
          return type['value'].toLowerCase().contains(query) || type['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  final contactType = [
    {"value": "Email", "label": "Email"},
    {"value": "WhatsApp", "label": "WhatsApp"},
    {"value": "Phone Number", "label": "Phone Number"},
    {"value": "Telegram", "label": "Telegram"},
    {"value": "LinkedIn", "label": "LinkedIn"},
  ];

  final contactStatus = {
    "Email": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
      {"value": "Visited", "label": "Visited"},
      {"value": "Not Visited", "label": "Not Visited"},
    ],
    "WhatsApp": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
      {"value": "Visited", "label": "Visited"},
      {"value": "Not Visited", "label": "Not Visited"},
    ],
    "Phone Number": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
      {"value": "Visited", "label": "Visited"},
      {"value": "Not Visited", "label": "Not Visited"},
    ],
    "Telegram": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
      {"value": "Visited", "label": "Visited"},
      {"value": "Not Visited", "label": "Not Visited"},
    ],
    "LinkedIn": [
      {"value": "Contacted", "label": "Contacted"},
      {"value": "Not Contacted", "label": "Not Contacted"},
      {"value": "Visited", "label": "Visited"},
      {"value": "Not Visited", "label": "Not Visited"},
    ],
  };

  Map<String, List<Map<String, String>>> contactDetailStatus = {
    "Contacted": [
      {"value": "Unreachable", "label": "Unreachable"},
      {"value": "No further response", "label": "No further response"},
    ],
    "Not Contacted": [],
    "Visited": [
      {"value": "Met PIC", "label": "Met PIC"},
      {"value": "Failed to meet PIC", "label": "Failed to meet PIC"},
    ],
    "Not Visited": [],
  };

  ContactClientPic createContactPIC() {
    ContactClientPic contactClientPic = ContactClientPic(
      type: selectedContactType.value?['value'],
      info: contactInfo.value.text,
      status: selectedContactStatus.value?['value'],
      detail: selectedContactDetailStatus.value?['value'],
      note: contactNote.value.text,
    );
    clearData();
    return contactClientPic;
  }

  List<Map<String, String>> getList(String data) {
    switch (data) {
      case 'contactType':
        return contactType;
      case 'contactStatus':
        return contactStatus[selectedContactType.value?["value"]] ?? [];
      case 'contactDetailStatus':
        return contactDetailStatus[selectedContactStatus.value?["value"]] ?? [];
      default:
        return [];
    }
  }

  void setValue({
    required String data,
    required dynamic value,
  }) {
    switch (data) {
      case 'contactType':
        selectedContactType.value = value;
        selectedContactStatus.value = null;
        selectedContactDetailStatus.value = null;
        break;
      case 'contactStatus':
        selectedContactStatus.value = value;
        selectedContactDetailStatus.value = null;
        break;
      case 'contactDetailStatus':
        selectedContactDetailStatus.value = value;
        break;
      default:
        break;
    }
  }

  void setExistingValue(ContactClientPic contact) {
    if (contact.type != null) {
      selectedContactType.value = {
        'value': '${contact.type}',
        'label': '${contact.type}',
      };
    }
    contactInfo.value.text = contact.info ?? '';
    if (contact.status != null) {
      selectedContactStatus.value = {
        'value': '${contact.status}',
        'label': '${contact.status}',
      };
    }
    if (contact.detail != null) {
      selectedContactDetailStatus.value = {
        'value': '${contact.detail}',
        'label': '${contact.detail}',
      };
    }
    contactNote.value.text = contact.note ?? '';
  }
}

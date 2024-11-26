import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  var search = Rx<String?>(null);

  final meetingTopic = Rx<List<TextEditingController>>(
    [TextEditingController(text: "")], // Teks awal kosong
  );

  final meetingSchedule = Rx<List<TextEditingController>>(
    [TextEditingController(text: "")], // Teks awal kosong
  );

  var selectedStatusActivity = Rx<List<Map<String, String>?>>([{}]);
  var selectedTypeActivity = Rx<List<List<Map<String, String>?>>>([[]]);

  var isAvailableToUser = <bool>[false].obs;

  final meetingNote = Rx<List<TextEditingController>>(
    [TextEditingController(text: "")], // Teks awal kosong
  );

  final remarksMeeting = TextEditingController();
  final addtionalNoteMeeting = TextEditingController();

  void addMoreActivity() {
    meetingTopic.value.add(TextEditingController(text: ""));
    meetingSchedule.value.add(TextEditingController(text: ""));

    selectedStatusActivity.value.add({});
    selectedTypeActivity.value.add([]);
    
    isAvailableToUser.add(false);
    meetingNote.value.add(TextEditingController(text: ""));

    meetingTopic.refresh();
    meetingSchedule.refresh();
    selectedStatusActivity.refresh();
    selectedTypeActivity.refresh();
    isAvailableToUser.refresh();
    meetingNote.refresh();
  }

  void deleteActivity(int index) {
    meetingTopic.value.removeAt(index);
    meetingSchedule.value.removeAt(index);
    selectedStatusActivity.value.removeAt(index);
    selectedTypeActivity.value.removeAt(index);
    isAvailableToUser.removeAt(index);
    meetingNote.value.removeAt(index);

    meetingTopic.refresh();
    meetingSchedule.refresh();
    selectedStatusActivity.refresh();
    selectedTypeActivity.refresh();
    isAvailableToUser.refresh();
    meetingNote.refresh();
  }

  void addStatus(int index, Map<String, String> type) {
    selectedStatusActivity.value[index] = type;
  }

  // ADD, DELETE, CLEAR TYPE ACTIVITY
  void addType(int index, Map<String, String> type) {
    // Cek jika status yang dipilih adalah "all"
    if (type['value'] == "all") {
      // Kosongkan filter status jika ada status lain
      clearType(index);
      selectedTypeActivity.value[index].add(type);
    } else {
      // Tambahkan status baru jika belum ada di dalam list
      if (!selectedTypeActivity.value[index].contains(type)) {
        selectedTypeActivity.value[index].add(type);
      }
    }
  }

  void deleteType(int index, Map<String, String> type) {
    selectedTypeActivity.value[index].remove(type);
  }

  void clearType(int index) {
    selectedTypeActivity.value[index].clear();
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging
    print("Current Filter: ${select}");
    print("Current Search Query: ${search.value}");

    if (select.toLowerCase() == 'status_activity') {
      result = statusActivityList;

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

    if (select.toLowerCase() == 'type_activity') {
      result = typeActivityList;

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

  final statusActivityList = [
    {"value": "scheduled", "label": "Scheduled"},
    {"value": "on_progress", "label": "On Progress"},
    {"value": "canceled", "label": "Canceled"},
  ];

  final typeActivityList = [
    {"value": "mini_quick_research", "label": "Mini Quick Research"},
    {"value": "pitch_deck", "label": "Pitch Dect"},
    {
      "value": "prospective_client_pic_replacement",
      "label": "Prospective Client PIC Replacement"
    },
    {
      "value": "prospective_client_request",
      "label": "Prospective Client Request"
    },
    {"value": "quotation_letter", "label": "Quotation Letter"},
    {"value": "mou_letter", "label": "MOU Letter"},
    {"value": "follow_up", "label": "Follow Up"},
  ];
}

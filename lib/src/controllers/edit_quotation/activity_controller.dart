import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityController extends GetxController {
  var search = Rx<String?>(null);

  final meetingTopic = Rx<List<TextEditingController>>([]);

  final meetingSchedule = Rx<List<TextEditingController>>([]);

  var selectedStatusActivity = Rx<List<Map<String, String>?>>([{}]);
  var selectedTypeActivity = Rx<List<List<Map<String, String>?>>>([[]]);

  var isAvailableToUser = <bool>[].obs;

  final meetingNote = Rx<List<TextEditingController>>([]);

  final remarksMeeting = TextEditingController();
  final addtionalNoteMeeting = TextEditingController();

  void loadData(
    List<String?> topic,
    List<DateTime?> schedule,
    List<String?> status,
    List<List<String>?> type,
    List<String?> note,
    String? remarks,
    String? addtionalNote,
  ) {
    // Update meetingTopic
    if (topic.length != 0) {
      meetingTopic.value =
          topic.map((t) => TextEditingController(text: t ?? "")).toList();
    } else {
      meetingTopic.value = [TextEditingController()];
    }

    // Update meetingSchedule
    if (schedule.isNotEmpty) {
      meetingSchedule.value = schedule.map((s) {
        // Format tanggal ke dalam format yang diinginkan
        final formattedDate =
            s != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(s) : "";
        return TextEditingController(text: formattedDate);
      }).toList();
    } else {
      meetingSchedule.value = [TextEditingController()];
    }

    // Update selectedStatusActivity
    if (status.length != 0) {
      selectedStatusActivity.value = status
          .where((s) => s != null)
          .map((s) => {"value": s!, "label": s})
          .toList();
    } else {
      selectedStatusActivity.value = [{}];
    }

    if (type.isNotEmpty) {
      // Jika type tidak kosong, lakukan mapping seperti biasa
      selectedTypeActivity.value = type.map((innerList) {
        if (innerList != null) {
          return innerList
              .map((item) {
                return {"value": item, "label": item};
              })
              .whereType<Map<String, String>>() // Hanya elemen yang valid
              .toList();
        }
        return <Map<String, String>>[];
      }).toList() as List<List<Map<String, String>?>>;
    } else {
      // Jika type kosong, buat list kosong sesuai jumlah topik
      selectedTypeActivity.value =
          List.generate(topic.length, (_) => <Map<String, String>?>[]);
    }

    // print(selectedTypeActivity.value);

    // Update isAvailableToUser
    isAvailableToUser.value =
        List.generate(meetingTopic.value.length, (index) => false);

    // Update meetingNote
    if (note.length != 0) {
      meetingNote.value =
          note.map((n) => TextEditingController(text: n ?? "")).toList();
    } else {
      meetingNote.value = [TextEditingController()];
    }

    // Update remarksMeeting
    remarksMeeting.text = remarks ?? "";

    // Update additionalNoteMeeting
    addtionalNoteMeeting.text = addtionalNote ?? "";
  }

  void clearData() {
    // Clear all variables
    meetingTopic.value.clear();
    meetingSchedule.value.clear();
    selectedStatusActivity.value.clear();
    selectedTypeActivity.value.clear();
    isAvailableToUser.clear();
    meetingNote.value.clear();
    remarksMeeting.clear();
    addtionalNoteMeeting.clear();

    // Set dummy data
    meetingTopic.value = [TextEditingController()];
    meetingSchedule.value = [TextEditingController()];
    selectedStatusActivity.value = [{}];
    selectedTypeActivity.value = [[]];
    isAvailableToUser.value = [false];
    meetingNote.value = [TextEditingController()];

    // Refresh observable lists
    meetingTopic.refresh();
    meetingSchedule.refresh();
    selectedStatusActivity.refresh();
    selectedTypeActivity.refresh();
    isAvailableToUser.refresh();
    meetingNote.refresh();
  }

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
  void addTypeActivity(int index, List<Map<String, String>?> data) {
    // Tambahkan status baru jika belum ada di dalam list
    print("tambah data $data pada activity ke - $index");
    // print("tambah data $types, pada activity ke $index");
    clearType(index);

    selectedTypeActivity.value[index] = data;
    // if (!selectedTypeActivity.value[index]
    //     .any((existingType) => existingType?['value'] == type['value'])) {
    //   selectedTypeActivity.value[index].add(type);
    // }
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
    {"value": "Scheduled", "label": "Scheduled"},
    {"value": "On Progress", "label": "On Progress"},
    {"value": "Canceled", "label": "Canceled"},
  ];

  final typeActivityList = [
    {"value": "Mini Quick Research", "label": "Mini Quick Research"},
    {"value": "Pitch Deck", "label": "Pitch Deck"},
    {
      "value": "Prospective Client PIC Replacement",
      "label": "Prospective Client PIC Replacement"
    },
    {
      "value": "Prospective Client Request",
      "label": "Prospective Client Request"
    },
    {"value": "Quotation Letter", "label": "Quotation Letter"},
    {"value": "MOU Letter", "label": "MOU Letter"},
    {"value": "Follow Up", "label": "Follow Up"},
  ];
}

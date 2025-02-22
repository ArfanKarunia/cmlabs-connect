import 'dart:convert';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/activity_controller.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/client_pic_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/general_info_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/url_tracking_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controler.dart';
import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../utils/toast.dart';

class EditQuotationController extends GetxController {
  var isChanged = false.obs;

  // General Info
  Map<String, String>? initialPic;
  Map<String, String>? initialPriority;
  Map<String, String>? initialStatus;
  Map<String, String>? initialType;

  // Client PIC
  List<ClientPic>? initialClientPics;

  List<List<Map<String, String>?>>? initialContactType;
  List<List<Map<String, String>?>>? initialContactStatus;
  List<List<Map<String, String>?>>? initialContactDetail;
  List<List<String?>>? initialContactInfo;
  List<List<String?>>? initialContactNote;

  // Activity
  late List<String?> initialMeetingTopics;
  late List<String?> initialMeetingSchedules;
  late List<Map<String, String>?> initialSelectedStatusActivity;
  late List<List<Map<String, String>?>> initialSelectedTypeActivity;
  late List<String?> initialMeetingNotes;
  late List<bool?> initialAvailabletoUser;
  late String? initialRemarksMeeting;
  late String? initialAdditionalNoteMeeting;

  // Activity
  late bool initialUrlTrackingStatus;

  final AuthenticationController authenticationController = Get.put(AuthenticationController());

  final UserControler userControler = Get.put(UserControler());
  final DetailQuotationController detailQuotationController = Get.put(DetailQuotationController());
  final GeneralInfoController generalInfoController = Get.put(GeneralInfoController());
  final ClientPicController clientPicController = Get.put(ClientPicController());
  final ActivityController activityController = Get.put(ActivityController());
  final UrlTrackingController urlTrackingController = Get.put(UrlTrackingController());

  final baseUrl = Config.baseURL;
  final dio = Dio();

  /*

    SETTING

    - SYNC DATA WITH FIELD
    - SEND API UPDATE QUOTATION
    - FORMAT DATA QUOTAION

  */

  void loadExistingData() async {
    await generalInfoController.fetchFilter("pic");
    await generalInfoController.fetchFilter("priority");
    await generalInfoController.fetchFilter("status");

    var quotation = detailQuotationController.quotation.value!;

    // print("${quotation.data.pic}");
    print("${quotation.data.clientPIC}");

    await generalInfoController.loadData(quotation.data.pic, quotation.priority, quotation.status, quotation.data.type);
    await clientPicController.loadData(quotation.data.clientPIC);

    activityController.loadData(
        quotation.data.meetingTopic,
        quotation.data.meetingSchedule,
        quotation.data.meetingStatus,
        quotation.data.meetingType,
        quotation.data.meetingNote,
        quotation.data.remarks,
        quotation.data.addtionalNotes);

    setInitialValues();

    isChanged.value = false;
    onFieldChanged();
  }

  void clearSelectedData() {
    generalInfoController.clearSelectedData();
    clientPicController.clearData();
    activityController.clearData();

    isChanged.value = false;
  }

  void checkForChanges() {
    List<List<Map<String, String>?>> currentContactType = clientPicController.selectedContactType.value
        .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
        .toList();

    List<List<Map<String, String>?>> currentContactStatus = clientPicController.selectedContactStatus.value
        .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
        .toList();

    List<List<Map<String, String>?>> currentContactDetail = clientPicController.selectedDetailStatus.value
        .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
        .toList();

    List<List<String?>> currentContactInfo = clientPicController.infoContact.value
        .map((innerList) => innerList?.map((controller) => controller?.text).toList() ?? [])
        .toList();

    List<List<String?>> currentContactNote = clientPicController.noteContact.value
        .map((innerList) => innerList?.map((controller) => controller?.text).toList() ?? [])
        .toList();

    List<String?> currentMeetingTopic =
        activityController.meetingTopic.value.map((controller) => controller.text).toList();

    List<String?> currentMeetingSchedules =
        activityController.meetingSchedule.value.map((controller) => controller.text).toList();

    List<bool?> currentAvailableToUser = List.from(activityController.isAvailableToUser);

    List<Map<String, String>?> currentSelectedStatusActivity =
        List.from(activityController.selectedStatusActivity.value);
    List<List<Map<String, String>?>> currentSelectedTypeActivity =
        List.from(activityController.selectedTypeActivity.value);
    List<String?> currentMeetingNotes =
        activityController.meetingNote.value.map((controller) => controller.text).toList();
    String? currentRemarksMeeting = activityController.remarksMeeting.text;
    String? currentAdditionalNoteMeeting = activityController.addtionalNoteMeeting.text;

    bool currentUrlTrackingStatus = urlTrackingController.isTracking.value;

    if (generalInfoController.selectPic.value != initialPic ||
        generalInfoController.selectPriority.value != initialPriority ||
        generalInfoController.selectStatus.value != initialStatus ||
        generalInfoController.selectType.value != initialType ||
        !listEquals(clientPicController.selectedPICClient, initialClientPics) ||
        !deepListEquals(currentContactType, initialContactType) ||
        !deepListEquals(currentContactStatus, initialContactStatus) ||
        !deepListEquals(currentContactDetail, initialContactDetail) ||
        !deepStringListEquals(currentContactInfo, initialContactInfo) ||
        !deepStringListEquals(currentContactNote, initialContactNote) ||
        !listEquals(currentMeetingTopic, initialMeetingTopics) ||
        !listEquals(currentMeetingSchedules, initialMeetingSchedules) ||
        !listEquals(currentSelectedStatusActivity, initialSelectedStatusActivity) ||
        !listEquals(currentAvailableToUser, initialAvailabletoUser) ||
        !listEquals(currentSelectedTypeActivity, initialSelectedTypeActivity) ||
        !listEquals(currentMeetingNotes, initialMeetingNotes) ||
        currentRemarksMeeting != initialRemarksMeeting ||
        currentAdditionalNoteMeeting != initialAdditionalNoteMeeting ||
        currentUrlTrackingStatus != initialUrlTrackingStatus) {
      isChanged.value = true;
    } else {
      isChanged.value = false;
    }
  }

  void onFieldChanged() {
    checkForChanges();
  }

  void setInitialValues() {
    // Simpan data awal General Information
    initialPic = generalInfoController.selectPic.value;
    initialPriority = generalInfoController.selectPriority.value;
    initialStatus = generalInfoController.selectStatus.value;
    initialType = generalInfoController.selectType.value;

    // Simpan data awal Client PIC
    initialClientPics = List.from(clientPicController.selectedPICClient);

    // initialContactData = clientPicController.getContactData();
    initialContactType = clientPicController.selectedContactType.value
        .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
        .toList();

    initialContactStatus = clientPicController.selectedContactStatus.value
        .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
        .toList();

    initialContactDetail = clientPicController.selectedDetailStatus.value
        .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
        .toList();

    initialContactInfo = clientPicController.infoContact.value
        .map((innerList) => innerList?.map((controller) => controller?.text).toList() ?? [])
        .toList();

    initialContactNote = clientPicController.noteContact.value
        .map((innerList) => innerList?.map((controller) => controller?.text).toList() ?? [])
        .toList();

    initialContactStatus = List.from(clientPicController.selectedContactStatus.value);
    initialContactDetail = List.from(clientPicController.selectedDetailStatus.value);
    initialContactInfo = clientPicController.infoContact.value
        .map((list) => list?.map((controller) => controller?.text).toList() ?? [])
        .toList();
    initialContactNote = clientPicController.noteContact.value
        .map((list) => list?.map((controller) => controller?.text).toList() ?? [])
        .toList();

    // Simpan data awal activity
    initialMeetingTopics = activityController.meetingTopic.value.map((controller) => controller.text).toList();

    initialMeetingSchedules = activityController.meetingSchedule.value.map((controller) => controller.text).toList();

    initialAvailabletoUser = List.from(activityController.isAvailableToUser);

    initialSelectedStatusActivity = List.from(activityController.selectedStatusActivity.value);

    initialSelectedTypeActivity = List.from(activityController.selectedTypeActivity.value);

    initialMeetingNotes = activityController.meetingNote.value.map((controller) => controller.text).toList();

    initialRemarksMeeting = activityController.remarksMeeting.text;
    initialAdditionalNoteMeeting = activityController.addtionalNoteMeeting.text;

    // simpan data awal URL Tracking
    initialUrlTrackingStatus = urlTrackingController.isTracking.value;
  }

  void clearInitialValue() {
// Simpan data awal General Information
    initialPic = null;
    initialPriority = null;
    initialStatus = null;
    initialType = null;

    // Simpan data awal Client PIC
    initialClientPics = null;

    // Simpan data awal Contact dari Client PIC
    initialContactType = null;
    initialContactStatus = null;
    initialContactDetail = null;
    initialContactInfo = null;
    initialContactNote = null;

    initialUrlTrackingStatus = false;
    urlTrackingController.isTracking.value = false;

    isChanged.value = false;
  }

  Future<void> updateQuotation(Quotation quotation) async {
    String? accessToken = userControler.accesToken.value;

    var data = formatDataQuotation(quotation);

    print(data);

    try {
      final response = await dio.put(
        "$baseUrl/quotation/update/${quotation.id}",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: data,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Data berhasil diupdate: ${response.data}');
        showSuccessToast("Success: Update Quotation dengan id : ${quotation.id}");
        Get.back();
      } else {
        print('Gagal mengupdate data. Status code: ${response.statusCode}');
        showErrorToast("Failed: Update Quotation dengan id : ${quotation.id}, karena");
      }
    } catch (e) {
      print("Error: $e");
      showErrorToast("Failed: Update Quotation dengan id : ${quotation.id}");
    }
  }

  String formatDataQuotation(Quotation quotation) {
    UrlTrackingController urlTrackingController = Get.put(UrlTrackingController());

    ActivityController activityController = Get.put(ActivityController());

    ClientPicController clientPicController = Get.put(ClientPicController());

    GeneralInfoController generalInfoController = Get.put(GeneralInfoController());

    var pic = generalInfoController.selectPic.value?["value"];
    var priority = generalInfoController.selectPriority.value?["value"];
    var status = generalInfoController.selectStatus.value?["value"];
    var type = generalInfoController.selectType.value?["value"];

    // Mengonversi list ClientPic ke dalam format JSON
    var clientPic = {};
    if (clientPicController.selectedPICClient.isNotEmpty) {
      for (var i = 0; i < clientPicController.selectedPICClient.length; i++) {
        var client = clientPicController.selectedPICClient[i];
        var contacts = [];

        // Mengumpulkan informasi kontak untuk setiap PIC
        if (clientPicController.selectedContactType.value.isNotEmpty) {
          for (var j = 0; j < clientPicController.selectedContactType.value[i].length; j++) {
            var contactType = clientPicController.selectedContactType.value[i][j];
            var contactStatus = clientPicController.selectedContactStatus.value[i][j];
            var contactDetailStatus = clientPicController.selectedDetailStatus.value[i][j];
            var contactInfo = clientPicController.infoContact.value[i]?[j];
            var contactNote = clientPicController.noteContact.value[i]?[j];

            // Pastikan semua data ada sebelum menambahkannya ke daftar kontak
            if (contactType != null && contactInfo != null) {
              contacts.add({
                "type": contactType['value'],
                "info": contactInfo.text,
                "status": contactStatus?['value'] ?? '',
                "detail": contactDetailStatus?['value'] ?? '',
                "note": contactNote?.text,
              });
            }
          }
        }

        // Menambahkan informasi PIC ke dalam clientPic
        clientPic[i.toString()] = {
          "name": client.name,
          "position": client.position,
          "contacts": contacts,
        };
      }
    }

    var meetingTopic = [];
    var meetingSchedule = [];
    var meetingStatus = [];
    var meetingType = [];
    var meetingNote = [];
    var meetingAvailableToUser =
        activityController.isAvailableToUser.map((available) => available ? "1" : "0").toList();

    var remarks = activityController.remarksMeeting.text;
    var notes = activityController.addtionalNoteMeeting.text;

    if (activityController.meetingTopic.value.isNotEmpty) {
      for (var topic in activityController.meetingTopic.value) {
        if (topic.text != "") {
          meetingTopic.add(topic.text);
        }
      }
      for (var i = 0; i < activityController.meetingTopic.value.length; i++) {}
    }

    if (activityController.meetingSchedule.value.isNotEmpty) {
      for (var schedule in activityController.meetingSchedule.value) {
        if (schedule.text != "") {
          meetingSchedule.add(schedule.text);
        }
      }
    }

    if (activityController.selectedStatusActivity.value.isNotEmpty) {
      for (var status in activityController.selectedStatusActivity.value) {
        if (status?['value'] != null) {
          meetingStatus.add(status?['value']);
        }
      }
    }

    if (activityController.selectedTypeActivity.value.isNotEmpty) {
      for (var outerList in activityController.selectedTypeActivity.value) {
        var temp = [];
        if (outerList.isNotEmpty) {
          for (var typeMap in outerList) {
            if (typeMap?['value'] != null) {
              temp.add(typeMap?['value']);
            }
          }
        }
        meetingType.add(temp);
      }
    }

    if (activityController.meetingNote.value.isNotEmpty) {
      for (var note in activityController.meetingNote.value) {
        if (note.text != "") {
          meetingNote.add(note.text);
        }
      }
    }

    Map<String, dynamic> requestData = {
      "project_tracker": "true",
      "pic": pic,
      "priority": priority,
      "status": status,
      "type": [type],
      "client_pic": clientPic,
      "meeting_topic": meetingTopic,
      "meeting_schedule": meetingSchedule,
      "meeting_status": meetingStatus,
      "meeting_type": meetingType,
      "meeting_available_to_user": meetingAvailableToUser,
      "meeting_note": meetingNote,
      "remarks": remarks,
      "notes": notes,
      "url_track_status": urlTrackingController.isTracking.value,
      "url": urlTrackingController.urlController.text,
      "password": urlTrackingController.passwordController.text,
      "validity": urlTrackingController.selectedValidity.value?['value'] ?? ''
    };

    return jsonEncode(requestData);
  }

  bool deepListEquals(List<List<Map<String, String>?>>? list1, List<List<Map<String, String>?>>? list2) {
    if (list1 == null || list2 == null) return list1 == list2;
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].length != list2[i].length) return false;
      for (int j = 0; j < list1[i].length; j++) {
        Map<String, String>? map1 = list1[i][j];
        Map<String, String>? map2 = list2[i][j];

        if (map1 == null || map2 == null) {
          if (map1 != map2) return false;
        } else {
          if (!mapEquals(map1, map2)) return false;
        }
      }
    }
    return true;
  }

  bool deepStringListEquals(List<List<String?>>? list1, List<List<String?>>? list2) {
    if (list1 == null || list2 == null) return list1 == list2;
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].length != list2[i].length) return false;
      for (int j = 0; j < list1[i].length; j++) {
        if (list1[i][j] != list2[i][j]) return false;
      }
    }
    return true;
  }

  // void checkChanges(){

  //   List<List<Map<String, String>?>> currentContactType = clientPicController.selectedContactType.value
  //       .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
  //       .toList();

  //   List<List<Map<String, String>?>> currentContactStatus = clientPicController.selectedContactStatus.value
  //       .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
  //       .toList();

  //   List<List<Map<String, String>?>> currentContactDetail = clientPicController.selectedDetailStatus.value
  //       .map((innerList) => innerList.map((map) => Map<String, String>.from(map!)).toList())
  //       .toList();

  //   List<List<String?>> currentContactInfo = clientPicController.infoContact.value
  //       .map((innerList) => innerList?.map((controller) => controller?.text).toList() ?? [])
  //       .toList();

  //   List<List<String?>> currentContactNote = clientPicController.noteContact.value
  //       .map((innerList) => innerList?.map((controller) => controller?.text).toList() ?? [])
  //       .toList();

  //   List<String?> currentMeetingTopic = activityController.meetingTopic.value
  //       .map((controller) => controller.text)
  //       .toList();

  //   List<String?> currentMeetingSchedules = activityController.meetingSchedule.value
  //       .map((controller) => controller.text)
  //       .toList();

  //   List<bool?> currentAvailableToUser =  List.from(activityController.isAvailableToUser);

  //   List<Map<String, String>?> currentSelectedStatusActivity = List.from(activityController.selectedStatusActivity.value);
  //   List<List<Map<String, String>?>> currentSelectedTypeActivity = List.from(activityController.selectedTypeActivity.value);
  //   List<String?> currentMeetingNotes = activityController.meetingNote.value
  //       .map((controller) => controller.text)
  //       .toList();
  //   String? currentRemarksMeeting = activityController.remarksMeeting.text;
  //   String? currentAdditionalNoteMeeting = activityController.addtionalNoteMeeting.text;

  //   print("+++ CHECK CHANGES +++");
  //   print("initial pic: $initialPic");
  //   print("current pic: ${generalInfoController.selectPic.value}");
  //   print("has changed: ${generalInfoController.selectPic.value != initialPic}");
  //   print("");

  //   print("initial status: $initialStatus");
  //   print("current status: ${generalInfoController.selectStatus.value}");
  //   print("has changed: ${generalInfoController.selectPriority.value != initialPriority}");
  //   print("");

  //   print("initial priority: $initialPriority");
  //   print("current priority: ${generalInfoController.selectPriority.value}");
  //   print("has changed: ${generalInfoController.selectStatus.value != initialStatus}");
  //   print("");

  //   print("initial type: $initialType");
  //   print("current type: ${generalInfoController.selectType.value}");
  //   print("has changed: ${generalInfoController.selectType.value != initialType}");
  //   print("");

  //   print("initial client pic: $initialClientPics");
  //   print("current client pic: ${clientPicController.selectedPICClient}");
  //   print("has changed: ${!listEquals(clientPicController.selectedPICClient, initialClientPics)}");
  //   print("");

  //   print("initial contact type: $initialContactType");
  //   print("current contact type : $currentContactType");
  //   print("has changed: ${!deepListEquals(currentContactType, initialContactType)}");
  //   print("");

  //   print("initial contact status: $initialContactStatus");
  //   print("current contact status : $currentContactStatus");
  //   print("has changed: ${!deepListEquals(currentContactStatus, initialContactStatus)}");
  //   print("");

  //   print("initial contact detail: $initialContactDetail");
  //   print("current contact detail : $currentContactDetail");
  //   print("has changed: ${!deepListEquals(currentContactDetail, initialContactDetail)}");
  //   print("");

  //   print("initial contact info: $initialContactInfo");
  //   print("current contact info : $currentContactInfo");
  //   print("has changed: ${!deepStringListEquals(currentContactInfo, initialContactInfo)}");
  //   print("");

  //   print("initial contact note: $initialContactNote");
  //   print("current contact note : $currentContactNote");
  //   print("has changed: ${!deepStringListEquals(currentContactNote, initialContactNote)}");
  //   print("");

  //   print("initial meeting topic: $initialMeetingTopics");
  //   print("current meeting topic : $currentMeetingTopic");
  //   print("has changed: ${!listEquals(currentMeetingTopic, initialMeetingTopics)}");
  //   print("");

  //   print("initial meeting schedule: $initialMeetingSchedules");
  //   print("current meeting schedule : $currentMeetingSchedules");
  //   print("has changed: ${!listEquals(currentMeetingSchedules, initialMeetingSchedules)}");
  //   print("");

  //   print("initial meeting status: $initialSelectedStatusActivity");
  //   print("current meeting status : $currentSelectedStatusActivity");
  //   print("has changed: ${!listEquals(currentSelectedStatusActivity, initialSelectedStatusActivity)}");
  //   print("");

  //   print("initial meeting type: $initialSelectedTypeActivity");
  //   print("current meeting type : $currentSelectedTypeActivity");
  //   print("has changed: ${!listEquals(currentSelectedTypeActivity, initialSelectedTypeActivity)}");
  //   print("");

  //   print("initial meeting Available: $initialAvailabletoUser");
  //   print("current meeting Available : $currentAvailableToUser");
  //   print("has changed: ${!listEquals(currentAvailableToUser, initialAvailabletoUser)}");
  //   print("");

  //   print("initial meeting note: $initialMeetingNotes");
  //   print("current meeting note : $currentMeetingNotes");
  //   print("has changed: ${!listEquals(currentMeetingNotes, initialMeetingNotes)}");
  //   print("");

  //   print("initial meeting remarks: $initialRemarksMeeting");
  //   print("current meeting remarks : $currentRemarksMeeting");
  //   print("has changed: ${currentRemarksMeeting != initialRemarksMeeting}");
  //   print("");

  //   print("initial meeting additional note: $initialAdditionalNoteMeeting");
  //   print("current meeting additional note : $currentAdditionalNoteMeeting");
  //   print("has changed: ${currentAdditionalNoteMeeting != initialAdditionalNoteMeeting}");
  //   print("");
  // }
}

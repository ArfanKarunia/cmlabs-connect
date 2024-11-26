import 'dart:convert';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/activity_controller.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/client_pic_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/general_info_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/url_tracking_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../utils/toast.dart';

class EditQuotationController extends GetxController {
  var isChanged = false.obs;

  
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final GeneralInfoController generalInfoController = Get.put(GeneralInfoController());
  final baseUrl = Config.baseURL;
  final dio = Dio();

  @override
  void onInit() async {
    super.onInit();

    // await fetchList("pic");
    // await fetchList("priority");
    // await fetchList("status");

    // menangkap jika terdapt perubahan
    // ever<Map<String, String>?>(selectPic, (value) {
    //   print("selectPic changed: $value");
    //   isChanged.value = true;
    // });

    // ever<Map<String, String>?>(selectPriority, (value) {
    //   print("selectPriority changed: $value");
    //   isChanged.value = true;
    // });

    // ever<Map<String, String>?>(selectStatus, (value) {
    //   print("selectStatus changed: $value");
    //   isChanged.value = true;
    // });

    // ever<Map<String, String>?>(selectedType, (value) {
    //   print("selectedType changed: $value");
    //   isChanged.value = true;
    // });

    // for (var controller in nameControllers) {
    //   controller.addListener(() {
    //     // Jika teks berubah, tandai isChanged menjadi true
    //     if (controller.text.isNotEmpty) {
    //       isChanged.value = true;
    //     }
    //   });
    // }

    // // Menambahkan listener pada positionControllers
    // for (var controller in positionControllers) {
    //   controller.addListener(() {
    //     // Jika teks berubah, tandai isChanged menjadi true
    //     if (controller.text.isNotEmpty) {
    //       isChanged.value = true;
    //     }
    //   });
    // }

  }

  @override
  void onClose() {
    // for (var controller in nameControllers) {
    //   controller.dispose();
    // }
    // for (var controller in positionControllers) {
    //   controller.dispose();
    // }
    super.onClose();
  }

  /*

    SETTING

    - SYNC DATA WITH FIELD
    - SEND API UPDATE QUOTATION
    - FORMAT DATA QUOTAION

  */

  void loadExistingData(Quotation quotation) async {
    await generalInfoController.fetchList("pic");
    await generalInfoController.fetchList("priority");
    await generalInfoController.fetchList("status");

    generalInfoController.loadData(quotation.data.pic?.trim(), quotation.priority, quotation.status, quotation.data.type[0]);

  }

  void clearSelectedData() {
    generalInfoController.clearSelectedData();

  }

  Future<void> updateQuotation(Quotation quotation) async {
    String? accessToken = authenticationController.accesToken.value;

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
        showSuccessToast(
            "Success: Update Quotation dengan id : ${quotation.id}");
        Get.back();
      } else {
        print('Gagal mengupdate data. Status code: ${response.statusCode}');
        showErrorToast(
            "Failed: Update Quotation dengan id : ${quotation.id}, karena");
      }
    } catch (e) {
      print("Error: $e");
      showErrorToast("Failed: Update Quotation dengan id : ${quotation.id}");
    }
  }

  String formatDataQuotation(Quotation quotation) {
    UrlTrackingController urlTrackingController =
        Get.put(UrlTrackingController());

    ActivityController activityController = Get.put(ActivityController());

    ClientPicController clientPicController = Get.put(ClientPicController());

    GeneralInfoController generalInfoController = Get.put(GeneralInfoController());

    var pic = generalInfoController.selectPic.value?["value"];
    var priority = generalInfoController.selectPriority.value?["value"];
    var status = generalInfoController.selectStatus.value?["value"];
    // var type = generalInfoController.selectType.value?["value"];

    // Mengonversi list ClientPic ke dalam format JSON
    var clientPic;

    if (clientPicController.selectedPICClient.length > 0 &&
        clientPicController.selectedPICClient[0].name != null &&
        clientPicController.selectedPICClient[0].name != "") {
      clientPic = {
        for (var i = 0; i < clientPicController.selectedPICClient.length; i++)
          '$i': clientPicController.selectedPICClient[i].toJson()
      };
    }

    var meetingTopic = [];
    var meetingSchedule = [];
    var meetingStatus = [];
    var meetingType = [];
    var meetingNote = [];
    var meetingAvailableToUser = activityController.isAvailableToUser
        .map((available) => available ? "1" : "0")
        .toList();

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
      // "type": type ?? [],
      "client_pic": clientPic,
      "meeting_topic": meetingTopic,
      "meeting_schedule": meetingSchedule,
      "meeting_status": meetingStatus,
      "meeting_type": meetingType,
      "meeting_available_to_user": meetingAvailableToUser,
      "meeting_note": meetingNote,
      "remarks": remarks,
      "notes": notes,
      "url_track_status": urlTrackingController.isTracking.value ? "on" : "off",
      "url": urlTrackingController.urlController.text,
      "password": urlTrackingController.passwordController.text,
      "validity": urlTrackingController.selectedValidity.value?['value'] ?? ''
    };

    return jsonEncode(requestData);
  }

  
}

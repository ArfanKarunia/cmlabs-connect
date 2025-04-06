import 'package:dio/dio.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/config.dart';
import '../../../models/client_pic_model.dart';
import '../../../models/form_case_studies_model.dart';
import '../../../models/project_history_model.dart';
import '../../../utils/toast.dart';
import '../../user/user_controller.dart';

class EditCaseStudiesController extends GetxController {
  int caseStudiesId = 0;

  RxList<Map<String, String>> picList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> selectedPic = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> priorityList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> selectedPriority = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> statusList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> selectedStatus = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> typeList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> selectedType = <Map<String, String>>[].obs;

  // PIC (Client Side)
  RxList<ClientPic> picClients = <ClientPic>[].obs;
  RxList<TextEditingController> picNameControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> picPositionControllers = <TextEditingController>[].obs;

  // Activity
  RxList<TextEditingController> activityName = <TextEditingController>[].obs;
  RxList<DateTime?> activitySchedule = <DateTime?>[].obs;
  RxList<Map<String, String>> activityStatusList = <Map<String, String>>[
    {'value': '0', 'label': 'Scheduled'},
    {'value': '1', 'label': 'On Progress'},
    {'value': '2', 'label': 'Canceled'},
  ].obs;
  RxList<Map<String, String>?> activityStatus = <Map<String, String>?>[].obs;
  RxList<Map<String, String>> activityTypeList = <Map<String, String>>[].obs;
  RxList<Map<String, String>?> activityType = <Map<String, String>?>[].obs;
  RxList<bool> activityAvailableToUser = <bool>[].obs;
  RxList<TextEditingController> activityNote = <TextEditingController>[].obs;
  Rx<TextEditingController> activityRemarks = TextEditingController().obs;
  Rx<TextEditingController> activityAdditionalNotes = TextEditingController().obs;

  // Url Tracking
  Rx<bool> urlTrackingEnabled = false.obs;
  Rx<String?> urlTrackingUrl = Rx<String?>(null);
  Rx<String?> urlTrackingInitialPassword = Rx<String?>(null);
  Rx<TextEditingController> urlTrackingPassword = TextEditingController().obs;
  Rx<DateTime?> urlTrackingExpired = Rx<DateTime?>(null);
  RxList<Map<String, String>> validityList = <Map<String, String>>[
    {'value': '1', 'label': '1 month'},
    {'value': '2', 'label': '2 months'},
    {'value': '3', 'label': '3 months'},
    {'value': '6', 'label': '6 months'},
  ].obs;
  Rx<Map<String, String>?> selectedValidity = Rx<Map<String, String>?>(null);

  // History
  RxList<ProjectHistory> historyList = <ProjectHistory>[].obs;

  Rx<bool> isLoading = false.obs;

  final UserController userController = Get.find<UserController>();
  final http.Dio dio = http.Dio();
  final baseUrl = Config.baseURL;

  @override
  void dispose() {
    for (TextEditingController controller in picNameControllers) {
      controller.dispose();
    }
    for (TextEditingController controller in picPositionControllers) {
      controller.dispose();
    }
    for (TextEditingController controller in activityName) {
      controller.dispose();
    }
    for (TextEditingController controller in activityNote) {
      controller.dispose();
    }
    activityRemarks.value.dispose();
    activityAdditionalNotes.value.dispose();
    urlTrackingPassword.value.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    fetchPic();
    fetchPriority();
    fetchStatus();
    fetchActivityType();
  }

  void addNewActivity() {
    activityName.add(TextEditingController());
    activitySchedule.add(null);
    activityStatus.add(null);
    activityType.add(null);
    activityAvailableToUser.add(false);
    activityNote.add(TextEditingController());
  }

  void removeActivity(int index) {
    activityName[index].dispose();
    activityNote[index].dispose();

    activityName.removeAt(index);
    activitySchedule.removeAt(index);
    activityStatus.removeAt(index);
    activityType.removeAt(index);
    activityAvailableToUser.removeAt(index);
    activityNote.removeAt(index);
  }

  void addClientPic() {
    picNameControllers.add(TextEditingController());
    picPositionControllers.add(TextEditingController());
    picClients.add(ClientPic(contacts: []));
  }

  void addClientPicContact({required int index, required ContactClientPic contact}) {
    final contactList = picClients[index].contacts;
    contactList.add(contact);
    picClients[index].copyWith(contacts: contactList);
  }

  void editClientPicContact({
    required int clientIndex,
    required int contactIndex,
    required ContactClientPic contact,
  }) {
    final indexed = picClients[clientIndex].contacts[contactIndex];
    picClients[clientIndex].contacts[contactIndex] = indexed.copyWith(
      type: contact.type,
      info: contact.info,
      status: contact.status,
      detail: contact.detail,
      note: contact.note,
    );
  }

  void removeClientPIC(int index) {
    picNameControllers[index].dispose();
    picPositionControllers[index].dispose();

    picNameControllers.removeAt(index);
    picPositionControllers.removeAt(index);
    picClients.removeAt(index);
  }

  Future<void> fetchData(int id) async {
    final response = await dio.get(
      '$baseUrl/case-studies/view-form-case-study-detail/$id',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'];

      if (rawData != null) {
        final formCaseStudies = FormCaseStudies.fromJson(rawData);
        setInitialValue(formCaseStudies);
        caseStudiesId = id;
      }
    }
  }

  Future<void> fetchPic() async {
    final response = await dio.get(
      '$baseUrl/filter/pic',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final pics = (response.data['data'] as List<dynamic>).map((pic) {
        return {
          'value': pic['value']?.toString() ?? '',
          'label': pic['label']?.toString() ?? '',
        };
      }).toList();
      picList.assignAll(pics);
    }
  }

  Future<void> fetchPriority() async {
    final response = await dio.get(
      '$baseUrl/quotation/list_priority',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final priorities = (response.data['data'] as List<dynamic>).map((priority) {
        return {
          'value': priority['value']?.toString() ?? '',
          'label': priority['label']?.toString() ?? '',
        };
      }).toList();
      priorityList.assignAll(priorities);
    }
  }

  Future<void> fetchStatus() async {
    final response = await dio.get(
      '$baseUrl/quotation/list_status',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final statuses = (response.data['data'] as List<dynamic>).map((status) {
        return {
          'value': status['value']?.toString() ?? '',
          'label': status['label']?.toString() ?? '',
        };
      }).toList();
      statusList.assignAll(statuses);
    }
  }

  Future<void> fetchType() async {
    if (selectedStatus.value == null) {
      typeList.assignAll([]);
      return;
    }

    final response = await dio.get(
      '$baseUrl/quotation/fetch/get-data-type-project-information-by-status-or-all',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
      data: selectedStatus.value != null ? {"status": "${selectedStatus.value?["value"]}"} : null,
    );

    if (response.statusCode == 200 && response.data != null) {
      final List<String> types = List<String>.from(response.data['data'] ?? []);
      final List<Map<String, String>> mapTypes = types.map((type) {
        return {
          'value': type,
          'label': type,
        };
      }).toList();
      typeList.assignAll(mapTypes);
    }
  }

  Future<void> fetchActivityType() async {
    final response = await dio.get(
      '$baseUrl/quotation/fetch/get-data-type-activity',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final List<String> types = List<String>.from(response.data['data'] ?? []);
      final List<Map<String, String>> mapTypes = types.map((type) {
        return {
          'value': type,
          'label': type,
        };
      }).toList();
      activityTypeList.assignAll(mapTypes);
    }
  }

  void setInitialValue(FormCaseStudies formCaseStudies) {
    if (formCaseStudies.pic != null) {
      selectedPic.value = {
        'value': '${formCaseStudies.pic}',
        'label': '${formCaseStudies.pic}',
      };
    }
    selectedPriority.value = switch (formCaseStudies.priority) {
      1 => {"value": "1", "label": "Regular"},
      2 => {"value": "2", "label": "Immediate"},
      _ => null,
    };
    selectedStatus.value = switch (formCaseStudies.status) {
      0 => {"value": "0", "label": "New"},
      1 => {"value": "1", "label": "Followed Up"},
      2 => {"value": "2", "label": "Accepted"},
      3 => {"value": "3", "label": "Rejected"},
      4 => {"value": "4", "label": "On-Hold"},
      _ => null,
    };
    fetchType();
    if (formCaseStudies.type != null) {
      for (final type in formCaseStudies.type!) {
        selectedType.add({'value': type, 'label': type});
      }
    }

    for (final clientPic in formCaseStudies.picClientSide!) {
      picClients.add(clientPic);
      picNameControllers.add(TextEditingController(text: clientPic.name));
      picPositionControllers.add(TextEditingController(text: clientPic.position));
    }

    if (formCaseStudies.projectActivity != null) {
      for (final projectActivity in formCaseStudies.projectActivity!) {
        activityName.add(TextEditingController(text: projectActivity.meetingTopic));
        activitySchedule.add(projectActivity.meetingSchedule);
        if (projectActivity.meetingStatus != null) {
          activityStatus.add(activityStatusList[projectActivity.meetingStatus ?? 0]);
        }
        if (projectActivity.meetingType != null) {
          activityType.add({
            'value': '${projectActivity.meetingType}',
            'label': '${projectActivity.meetingType}',
          });
        }
        activityAvailableToUser.add(projectActivity.meetingAvailableToUser == 1);
        activityNote.add(TextEditingController(text: projectActivity.meetingNote));
      }
    }
    activityRemarks.value.text = formCaseStudies.remarks.toString();
    activityAdditionalNotes.value.text = formCaseStudies.additionalNotes.toString();

    urlTrackingEnabled.value = formCaseStudies.urlTracking != null;
    urlTrackingUrl.value = formCaseStudies.urlTracking?.url;
    urlTrackingInitialPassword.value = formCaseStudies.urlTracking?.password ?? '';
    urlTrackingPassword.value.text = formCaseStudies.urlTracking?.password ?? '';
    urlTrackingExpired.value = formCaseStudies.urlTracking?.expiredAt;

    if (formCaseStudies.projectHistory != null) {
      for (final history in formCaseStudies.projectHistory!) {
        historyList.add(history);
      }
    }
  }

  List<Map<String, String>> getList(String data) {
    switch (data) {
      case 'pic':
        return picList;
      case 'priority':
        return priorityList;
      case 'status':
        return statusList;
      case 'type':
        return typeList;
      case 'activityStatus':
        return activityStatusList;
      case 'activityType':
        return activityTypeList;
      case 'validity':
        return validityList;
      default:
        return [];
    }
  }

  void setValue({
    required String data,
    required dynamic value,
  }) {
    switch (data) {
      case 'pic':
        selectedPic.value = value;
        break;
      case 'priority':
        selectedPriority.value = value;
        break;
      case 'status':
        selectedStatus.value = value;
        selectedType.clear();
        fetchType();
        break;
      case 'type':
        selectedType.value = value;
        break;
      case 'validity':
        selectedValidity.value = value;
        break;
      default:
        break;
    }
  }

  void setActivityValue({
    required String data,
    required int index,
    required dynamic value,
  }) {
    switch (data) {
      case 'activitySchedule':
        activitySchedule[index] = value;
        break;
      case 'activityStatus':
        activityStatus[index] = value;
        break;
      case 'activityType':
        activityType[index] = value;
        break;
      default:
        break;
    }
  }

  void setHistoryValue({
    required String data,
    required int index,
    required dynamic value,
  }) {
    switch (data) {
      case 'availableToUser':
        historyList[index] = historyList[index].copyWith(availableToUser: value);
        break;
      default:
        break;
    }
  }

  Future<void> deleteHistory(int? id) async {
    try {
      final accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty || id == null) {
        showErrorToast('Gagal menghapus Quotation');
      }

      final response = await dio.delete(
        '$baseUrl/case-studies/delete-history-activity/$id',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        historyList.removeWhere((history) => history.id == id);
        showSuccessToast('Berhasil menghapus History');
      } else {
        showErrorToast('Gagal menghapus History');
        // debugPrint("Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      // debugPrint('Error fetching data: $e');
      showErrorToast('Terjadi kesalahan saat menghapus data');
    }
  }

  List<Map<String, dynamic>> createActivityList() {
    List<Map<String, dynamic>> activityArray = [];

    int itemCount = activityName.length;

    for (int i = 0; i < itemCount; i++) {
      Map<String, dynamic> activityItem = {
        "meeting_name_or_topic": activityName[i].text, // ntar diganti
        "meeting_schedule":
            activitySchedule[i] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(activitySchedule[i]!) : null,
        "meeting_status": activityStatus[i]?['value'],
        "meeting_type": activityType[i]?['value'],
        "meeting_available_to_user": activityAvailableToUser[i] ? 1 : 0,
        "meeting_note": activityNote[i].text,
      };

      activityArray.add(activityItem);
    }

    return activityArray;
  }

  Future<void> submitCaseStudies() async {
    for (int i = 0; i < picClients.length; i++) {
      picClients[i] = picClients[i].copyWith(
        name: picNameControllers[i].value.text,
        position: picPositionControllers[i].value.text,
      );
    }

    try {
      isLoading(true);

      final data = {
        "project_tracker": "true",
        "pic": selectedPic.value?['value'],
        "status": selectedStatus.value?['value'],
        "priority": selectedPriority.value?['value'],
        "type": selectedType.map((type) => type['value']).toList(),
        "client_pic": picClients.map((picClient) => picClient.toJson()).toList(),
        "activity": createActivityList(),
        "remarks": activityRemarks.value.text,
        "notes": activityAdditionalNotes.value.text,
        "url_track_status": urlTrackingEnabled.value,
        "url": urlTrackingUrl.value,
        "password": urlTrackingPassword.value.text,
        "validity": selectedValidity.value?['value'],
      };

      debugPrint(data.toString());

      final response = await dio.post(
        '$baseUrl/case-studies/safe-form-case-study-detail/$caseStudiesId',
        data: data,
        options: http.Options(
          headers: {
            // 'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );

      debugPrint(response.toString());

      isLoading(false);

      if (response.statusCode == 200) {
        showSuccessToast('Berhasil mengubah Case Study!');
        Get.back();
      }
    } on http.DioException catch (e) {
      isLoading(false);
      final errors = e.response?.data['message'];

      if (errors is Map) {
        errors.forEach(
          (key, value) {
            if (value is List) {
              for (var errorMessage in value) {
                Get.snackbar('Error', errorMessage, duration: const Duration(seconds: 1));
              }
            } else {
              Get.snackbar('Error', value, duration: const Duration(seconds: 1));
            }
          },
        );
      } else {
        Get.snackbar('Error', errors, duration: const Duration(seconds: 1));
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }
}

import 'package:dio/dio.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constant/config.dart';
import '../../models/inbox/property/client_pic_model.dart';
import '../../models/inbox/property/inbox_edit_form_model.dart';
import '../../models/inbox/property/project_history_model.dart';
import '../../utils/toast.dart';
import '../user/user_controller.dart';

class EditFormController extends GetxController {
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
    {'value': '1 month', 'label': '1 month'},
    {'value': '2 months', 'label': '2 months'},
    {'value': '3 months', 'label': '3 months'},
    {'value': '6 months', 'label': '6 months'},
  ].obs;
  Rx<Map<String, String>?> selectedValidity = Rx<Map<String, String>?>(null);

  // History
  RxList<ProjectHistory> historyList = <ProjectHistory>[].obs;

  // Error Text
  Rx<String?> projectPicError = Rx<String?>(null);
  Rx<String?> projectPriorityError = Rx<String?>(null);
  Rx<String?> projectStatusError = Rx<String?>(null);
  Rx<String?> projectTypeError = Rx<String?>(null);
  RxList<String?> picNameErrors = <String?>[].obs;
  RxList<String?> picPositionErrors = <String?>[].obs;
  RxList<String?> picContactErrors = <String?>[].obs;

  Rx<bool> isLoading = false.obs;
  Rx<bool> isUrlTrackingLoading = false.obs;

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

  Future<bool> validateForm() async {
    projectPicError.value = selectedPic.value == null ? 'The CMLABS PIC must not be empty.' : null;
    projectPriorityError.value = selectedPriority.value == null ? 'The priority must not be empty.' : null;
    projectStatusError.value = selectedStatus.value == null ? 'The status must not be empty.' : null;
    projectTypeError.value = selectedType.isEmpty ? 'The type must not be empty.' : null;

    for (int i = 0; i < picNameControllers.length; i++) {
      picNameErrors[i] = picNameControllers[i].text.isEmpty
          ? 'The PIC name must not be empty.'
          : picNameControllers[i].text.length > 25
              ? 'The maximum character of PIC name is 25 characters.'
              : !RegExp(r'^[a-zA-Z\s]+$').hasMatch(picNameControllers[i].text)
                  ? 'The PIC name can only contain letters and spaces.'
                  : null;
      picPositionErrors[i] = picPositionControllers[i].text.isEmpty
          ? null
          : picPositionControllers[i].text.length > 20
              ? 'The maximum character of position is 20 characters.'
              : null;
      picContactErrors[i] = picClients[i].contacts.isEmpty ? 'The contact field is required.' : null;
    }

    bool isFormValid = projectPicError.value == null &&
        projectPriorityError.value == null &&
        projectStatusError.value == null &&
        projectTypeError.value == null &&
        picNameErrors.every((picNameError) => picNameError == null) &&
        picPositionErrors.every((picPositionError) => picPositionError == null) &&
        picContactErrors.every((picContactError) => picContactError == null);

    if (!isFormValid) {
      showErrorToast("Error: Please check the form and try again!");
    }

    return isFormValid;
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
    picNameErrors.add(null);
    picPositionControllers.add(TextEditingController());
    picPositionErrors.add(null);
    picClients.add(ClientPic(contacts: []));
    picContactErrors.add(null);
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
    picClients[clientIndex].contacts[contactIndex] = ContactClientPic(
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
    picNameErrors.removeAt(index);
    picPositionErrors.removeAt(index);
    picContactErrors.removeAt(index);
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
    if (selectedStatus.value == null) return;

    if (selectedStatus.value?['label'] == 'On-Hold') {
      typeList.assignAll([
        {'value': 'On-Hold', 'label': 'On-Hold'}
      ]);
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

  void setInitialValue(InboxEditForm inboxEditForm) {
    if (inboxEditForm.pic != null) {
      selectedPic.value = {
        'value': '${inboxEditForm.pic}',
        'label': '${inboxEditForm.pic}',
      };
    }
    selectedPriority.value = switch (inboxEditForm.priority) {
      1 => {"value": "1", "label": "Regular"},
      2 => {"value": "2", "label": "Immediate"},
      _ => null,
    };
    selectedStatus.value = switch (inboxEditForm.status) {
      0 => {"value": "0", "label": "New"},
      1 => {"value": "1", "label": "Followed Up"},
      2 => {"value": "2", "label": "Accepted"},
      3 => {"value": "3", "label": "Rejected"},
      4 => {"value": "4", "label": "On-Hold"},
      _ => null,
    };
    fetchType();
    if (inboxEditForm.type != null) {
      for (final type in inboxEditForm.type!) {
        selectedType.add({'value': type, 'label': type});
      }
    }

    for (final clientPic in inboxEditForm.picClientSide!) {
      picClients.add(clientPic);
      picNameControllers.add(TextEditingController(text: clientPic.name));
      picNameErrors.add(null);
      picPositionControllers.add(TextEditingController(text: clientPic.position));
      picPositionErrors.add(null);
      picContactErrors.add(null);
    }

    if (inboxEditForm.projectActivity != null) {
      for (final projectActivity in inboxEditForm.projectActivity!) {
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
    activityRemarks.value.text = inboxEditForm.remarks ?? '';
    activityAdditionalNotes.value.text = inboxEditForm.additionalNotes ?? '';

    urlTrackingEnabled.value = inboxEditForm.urlTracking != null;
    urlTrackingUrl.value = inboxEditForm.urlTracking?.url;
    urlTrackingInitialPassword.value = inboxEditForm.urlTracking?.password ?? '';
    urlTrackingPassword.value.text = inboxEditForm.urlTracking?.password ?? '';
    urlTrackingExpired.value = inboxEditForm.urlTracking?.expiredAt;

    if (inboxEditForm.projectHistory != null) {
      for (final history in inboxEditForm.projectHistory!) {
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
        selectedType.assignAll([]);
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

  List<Map<String, dynamic>> createActivityList() {
    List<Map<String, dynamic>> activityArray = [];

    int itemCount = activityName.length;

    for (int i = 0; i < itemCount; i++) {
      Map<String, dynamic> activityItem = {
        "meeting_topic": activityName[i].text,
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

  Future<String?> fetchUrlTracking(int id) async {
    final response = await dio.get(
      '$baseUrl/quotation/generate_url_tracker?id=$id',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data['data'];
    }

    return null;
  }

  Future<void> switchUrlTracking(int id, bool value) async {
    if (urlTrackingUrl.value == null && value == true) {
      isUrlTrackingLoading(true);
      urlTrackingUrl.value = await fetchUrlTracking(id);
      isUrlTrackingLoading(false);
    }

    urlTrackingEnabled(value);
  }

  Future<void> fetchData(int id) async {}
  Future<void> deleteHistory(int? id) async {}
  Future<void> submitForm() async {}
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;

import '../../../constant/config.dart';
import '../../../constant/const.dart';
import '../../../models/inbox/property/client_pic_model.dart';
import '../../../utils/agent_utils.dart';
import '../../../utils/toast.dart';
import '../../user/user_controller.dart';

class AddQuotationController extends GetxController {
  // QuotationForm
  RxList<Map<String, String>> companyNameList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> companyName = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> companyWebsiteList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> companyWebsite = Rx<Map<String, String>?>(null);
  Rx<Map<String, String>?> countryCode = Rx<Map<String, String>?>({
    'label': 'IDN (+62)',
    'value': '+62',
  });
  RxList<Map<String, String>> countryCodeList = <Map<String, String>>[].obs;
  Rx<TextEditingController> phoneNumber = TextEditingController().obs;

  // Project Information
  RxList<Map<String, String>> projectServiceList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> projectService = <Map<String, String>>[].obs;
  RxList<Map<String, String>> projectPicList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> projectPic = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> projectPriorityList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> projectPriority = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> projectClientSourceList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> projectClientSource = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> projectStatusList = <Map<String, String>>[].obs;
  Rx<Map<String, String>?> projectStatus = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>> projectTypeList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> projectType = <Map<String, String>>[].obs;

  // Activity
  Rx<TextEditingController> activityName = TextEditingController().obs;
  RxList<Map<String, String>> activityTypeList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> activityType = <Map<String, String>>[].obs;
  Rx<TextEditingController> activityNote = TextEditingController().obs;
  Rx<bool> availableToUser = false.obs;

  // PIC (Client Side)
  RxList<ClientPic> picClients = <ClientPic>[].obs;
  RxList<TextEditingController> picNameControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> picPositionControllers = <TextEditingController>[].obs;

  // Error Text
  Rx<String?> companyNameError = Rx<String?>(null);
  Rx<String?> companyWebsiteError = Rx<String?>(null);
  Rx<String?> phoneNumberError = Rx<String?>(null);
  Rx<String?> projectServiceError = Rx<String?>(null);
  Rx<String?> projectPicError = Rx<String?>(null);
  Rx<String?> projectPriorityError = Rx<String?>(null);
  Rx<String?> projectClientSourceError = Rx<String?>(null);
  Rx<String?> projectStatusError = Rx<String?>(null);
  Rx<String?> projectTypeError = Rx<String?>(null);
  Rx<String?> activityNameError = Rx<String?>(null);
  Rx<String?> activityTypeError = Rx<String?>(null);
  Rx<String?> fileError = Rx<String?>(null);
  RxList<String?> picNameErrors = <String?>[].obs;
  RxList<String?> picPositionErrors = <String?>[].obs;
  RxList<String?> picContactErrors = <String?>[].obs;

  Rx<bool> isLoading = false.obs;

  final userController = Get.find<UserController>();
  final dio = http.Dio();
  final baseUrl = Config.baseURL;

  @override
  void onReady() {
    fetchCompanyName();
    fetchCompanyWebsite();
    countryCodeList.assignAll(internationalPhoneCodes);
    fetchProjectService();
    fetchProjectPic();
    fetchProjectPriority();
    fetchProjectClientSource();
    fetchProjectStatus();
    fetchProjectType();
    fetchActivityType();
  }

  @override
  void dispose() {
    for (TextEditingController controller in picNameControllers) {
      controller.dispose();
    }
    for (TextEditingController controller in picPositionControllers) {
      controller.dispose();
    }
    phoneNumber.value.dispose();
    activityName.value.dispose();
    activityNote.value.dispose();
    super.dispose();
  }

  Future<bool> validateForm(File? file) async {
    companyNameError.value = companyName.value == null ? 'The company name must not be empty.' : null;
    companyWebsiteError.value = companyWebsite.value == null ? 'The company website must not be empty.' : null;
    phoneNumberError.value = phoneNumber.value.text.isEmpty
        ? 'The company phone number must not be empty.'
        : phoneNumber.value.text.length > 13
            ? 'The maximum company phone number is 13 digits.'
            : null;

    projectServiceError.value = projectService.isEmpty ? 'The service must not be empty.' : null;
    projectPicError.value = projectPic.value == null ? 'The CMLABS PIC must not be empty.' : null;
    projectPriorityError.value = projectPriority.value == null ? 'The priority must not be empty.' : null;
    projectClientSourceError.value = projectClientSource.value == null ? 'The client source must not be empty.' : null;
    projectStatusError.value = projectStatus.value == null ? 'The status must not be empty.' : null;
    projectTypeError.value = projectType.isEmpty ? 'The type must not be empty.' : null;

    activityNameError.value = activityName.value.text.isEmpty ? 'The activity name must not be empty.' : null;
    activityTypeError.value = activityType.isEmpty ? 'The activity type must not be empty.' : null;
    if (file != null) {
      final fileSize = await file.length();
      fileError.value = fileSize > 2 * 1024 * 1024 ? 'The maximum of file size is 2 MB !' : null;
    }

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

    bool isFormValid = companyNameError.value == null &&
        companyWebsiteError.value == null &&
        phoneNumberError.value == null &&
        projectServiceError.value == null &&
        projectPicError.value == null &&
        projectPriorityError.value == null &&
        projectClientSourceError.value == null &&
        projectStatusError.value == null &&
        projectTypeError.value == null &&
        activityNameError.value == null &&
        activityTypeError.value == null &&
        fileError.value == null &&
        picNameErrors.every((picNameError) => picNameError == null) &&
        picPositionErrors.every((picPositionError) => picPositionError == null) &&
        picContactErrors.every((picContactError) => picContactError == null);

    if (!isFormValid) {
      showErrorToast("Error: Please check the form and try again!");
    }

    return isFormValid;
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

  void removeClientPIC(int index) {
    picNameControllers[index].dispose();
    picPositionControllers[index].dispose();

    picNameControllers.removeAt(index);
    picNameErrors.removeAt(index);
    picPositionControllers.removeAt(index);
    picPositionErrors.removeAt(index);
    picClients.removeAt(index);
    picContactErrors.removeAt(index);
  }

  Future<void> fetchCompanyName() async {
    final response = await dio.get(
      '$baseUrl/quotation/fetch/get-data-all-company',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final companyNames = (response.data['data'] as List<dynamic>).map((data) {
        return {
          'value': data['company']?.toString() ?? '',
          'label': data['company']?.toString() ?? '',
        };
      }).toList();

      companyNameList.assignAll(companyNames);
    }
  }

  Future<void> fetchCompanyWebsite() async {
    final response = await dio.get(
      '$baseUrl/quotation/fetch/get-data-all-company-website',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final companyWebsites = (response.data['data'] as List<dynamic>).map((data) {
        return {
          'value': data['company_website']?.toString() ?? '',
          'label': data['company_website']?.toString() ?? '',
        };
      }).toList();
      companyWebsiteList.assignAll(companyWebsites);
    }
  }

  Future<void> fetchProjectService() async {
    final response = await dio.get(
      '$baseUrl/filter/data_services',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final services = (response.data['data'] as List<dynamic>).map((service) {
        return {
          'value': service['id']?.toString() ?? '',
          'label': service['text']?.toString() ?? '',
        };
      }).toList();
      projectServiceList.assignAll(services);
    }
  }

  Future<void> fetchProjectPic() async {
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
      projectPicList.assignAll(pics);
    }
  }

  Future<void> fetchProjectPriority() async {
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
      projectPriorityList.assignAll(priorities);
    }
  }

  Future<void> fetchProjectClientSource() async {
    final response = await dio.get(
      '$baseUrl/filter/client_source',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = (response.data['data'] as List<dynamic>).map((clientSource) {
        return {
          'value': clientSource['value']?.toString() ?? '',
          'label': clientSource['label']?.toString() ?? '',
        };
      }).toList();

      projectClientSourceList.assignAll(data);
    }
  }

  Future<void> fetchProjectStatus() async {
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
      projectStatusList.assignAll(statuses);
    }
  }

  Future<void> fetchProjectType() async {
    if (projectStatus.value == null) return;

    if (projectStatus.value?['label'] == 'On-Hold') {
      projectTypeList.assignAll([
        {'value': 'On-Hold', 'label': 'On-Hold'}
      ]);
      return;
    }

    final response = await dio.get(
      '$baseUrl/quotation/fetch/get-data-type-project-information-by-status-or-all',
      options: http.Options(
        headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
      ),
      data: projectStatus.value != null ? {"status": "${projectStatus.value?["value"]}"} : null,
    );

    if (response.statusCode == 200 && response.data != null) {
      final List<String> types = List<String>.from(response.data['data'] ?? []);
      final List<Map<String, String>> mapTypes = types.map((type) {
        return {
          'value': type,
          'label': type,
        };
      }).toList();
      projectTypeList.assignAll(mapTypes);
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

  List<Map<String, String>> getList(String data) {
    switch (data) {
      case 'companyName':
        return companyNameList;
      case 'companyWebsite':
        return companyWebsiteList;
      case 'countryCode':
        return countryCodeList;
      case 'projectService':
        return projectServiceList;
      case 'projectPic':
        return projectPicList;
      case 'projectPriority':
        return projectPriorityList;
      case 'projectClientSource':
        return projectClientSourceList;
      case 'projectStatus':
        return projectStatusList;
      case 'projectType':
        return projectTypeList;
      case 'activityType':
        return activityTypeList;
      default:
        return [];
    }
  }

  void addValue({
    required String data,
    required String value,
  }) {
    switch (data) {
      case 'companyName':
        companyNameList.add({'value': value, 'label': value});
        break;
      case 'companyWebsite':
        companyWebsiteList.add({'value': value, 'label': value});
        break;
      case 'projectService':
        projectServiceList.add({'value': value, 'label': value});
        break;
      case 'projectClientSource':
        projectClientSourceList.add({'value': value, 'label': value});
        break;
      case 'activityType':
        activityTypeList.add({'value': value, 'label': value});
        break;
      default:
        break;
    }
  }

  void setValue({
    required String data,
    required dynamic value,
  }) {
    switch (data) {
      case 'companyName':
        companyName.value = value;
        break;
      case 'companyWebsite':
        companyWebsite.value = value;
        break;
      case 'countryCode':
        countryCode.value = value;
        break;
      case 'projectService':
        projectService.value = value;
        break;
      case 'projectPic':
        projectPic.value = value;
        break;
      case 'projectPriority':
        projectPriority.value = value;
        break;
      case 'projectClientSource':
        projectClientSource.value = value;
        break;
      case 'projectStatus':
        projectStatus.value = value;
        projectType.assignAll([]);
        fetchProjectType();
        break;
      case 'projectType':
        projectType.value = value;
        break;
      case 'activityType':
        activityType.value = value;
        break;
      default:
        break;
    }
  }

  Future<void> submitQuotation(File? file) async {
    for (int i = 0; i < picClients.length; i++) {
      picClients[i] = picClients[i].copyWith(
        name: picNameControllers[i].value.text,
        position: picPositionControllers[i].value.text,
      );
    }

    try {
      isLoading(true);

      final isFormValid = await validateForm(file);
      if (!isFormValid) {
        isLoading(false);
        return;
      }

      // For agent
      String platform = AgentUtils.getPlatform();
      String deviceModel = await AgentUtils.getDevice();
      String ipAddress = await AgentUtils.getIp();
      Map<String, dynamic> agent = {
        "browser": "Cmlabs Connect App",
        "device": deviceModel,
        "ip": ipAddress,
        "language": ["en-us", "en", "id"],
        "platform": platform,
        "devices": "mobile"
      };

      http.FormData data = http.FormData.fromMap({
        "project_tracker": "true",

        "company_name": companyName.value?['value'] ?? '',
        "company_website": companyWebsite.value?['value'] ?? '',
        "phone_code": countryCode.value?['value'] ?? '+62',
        "phone_number": phoneNumber.value.text,

        "service": [projectService.map((service) => service['value']).toList()],
        "cmlabspic": projectPic.value?['value'] ?? '',
        "priority": projectPriority.value?['value'] ?? '1',
        "client_source": projectClientSource.value?['value'] ?? '',
        // "client_source_detail": jsonEncode({"vendor": null, "name": null, "contact": null}),
        "status": projectStatus.value?['value'] ?? '1',
        "typeInformation": [projectType.map((type) => type['value']).toList()],

        "activity_name": activityName.value.text,
        "activity_type": [activityType.map((type) => type['value']).toList()],
        "remarks": activityNote.value.text,
        "available_to_user": availableToUser.value ? "1" : "0",

        "client_pic": picClients.map((picClient) => picClient.toJson()).toList(),

        "agent": agent,

        if (file != null) "file": await http.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      final response = await dio.post(
        '$baseUrl/quotation/create-new',
        data: data,
        options: http.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${userController.accesToken}',
          },
        ),
      );

      isLoading(false);

      if (response.statusCode == 200) {
        showSuccessToast('Berhasil menambahkan Quotation!');
        Get.back();
      }
    } on http.DioException catch (e) {
      isLoading(false);
      showErrorToast('Error: ${e.response?.data}');
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }
}

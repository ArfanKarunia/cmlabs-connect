import 'dart:convert';
import 'dart:io';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:cmlabs_connect/src/models/achievement_model.dart';
import 'package:cmlabs_connect/src/models/certification_model.dart';
import 'package:cmlabs_connect/src/models/education_model.dart';
import 'package:cmlabs_connect/src/models/experience_model.dart';
import 'package:cmlabs_connect/src/models/organization_model.dart';
import 'package:cmlabs_connect/src/models/publication_model.dart';
import 'package:cmlabs_connect/src/models/user_model.dart';
import 'package:cmlabs_connect/src/models/volunteer_model.dart';
import 'package:cmlabs_connect/src/utils/toast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPkg;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final UserController userController = Get.put(UserController());
  final baseUrl = Config.baseURL;
  final Dio dio = Dio();

  /* 
     ++ SUMMARY ++
  
  */

  final specializationList = Rx<List<Map<String, dynamic>>>([]);

  var about = Rx<String?>(null);
  var specialization = Rx<List<String?>>([]);
  var isChecked = <bool>[].obs;

  Future<void> fetchSummary() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response1 = await dio.get(
        '$baseUrl/profile/get-summary?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response1.statusCode == 200 && response1.data != null) {
        var responseData = response1.data['data'];
        print(responseData);

        // Check if 'about' is null before assigning
        about.value = responseData['about'] ?? null;

        // Check if 'specialization' is null or not a List, then assign an empty list if needed
        if (responseData['specialization'] != null &&
            responseData['specialization'] is List) {
          var specList = List<String>.from(responseData['specialization']);
          specialization.value = specList;

          // Reset the isChecked list to match the specializationList length
          isChecked.value =
              List<bool>.filled(specializationList.value.length, false);

          // Iterate over the specialization data and match with specializationList
          for (var i = 0; i < specialization.value.length; i++) {
            var specializationName = specialization.value[i];

            // Match the specialization with the specializationList
            for (var j = 0; j < specializationList.value.length; j++) {
              if (specializationName == specializationList.value[j]['name']) {
                isChecked[j] = true; // Mark as checked if matched
              }
            }
          }
        } else {
          specialization.value = [];
          isChecked.value =
              List<bool>.filled(specializationList.value.length, false);
        }
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> fetchSpecializationList() async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/list-specialization',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;
        print(responseData);

        // Simpan data specialization
        specializationList.value = responseData
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();

        // Atur panjang isChecked sesuai dengan jumlah item dalam specialization
        isChecked.value =
            List<bool>.filled(specializationList.value.length, false);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteSummary() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-summary?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        about.value = null;
        specialization.value.clear;
        fetchSummary();

        showSuccessToast("Success: Delete Summary");
      } else {
        showErrorToast("Failed: Delete Summary");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addSumary() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      var data = {
        "id": idUser,
        "about": about.value,
        "specialization": specialization.value,
      };

      print(jsonEncode(data));

      final response = await dio.post('$baseUrl/profile/update-summary',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: jsonEncode(data));

      if (response.statusCode == 200 && response.data != null) {
        fetchSummary();
        showSuccessToast("Success: add Summary");
        Get.back();
      } else {
        showErrorToast("Failed: add Summary");
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ EXPERIENCE ++

  */
  final projectList = Rx<List<Map<String, dynamic>>>([]);

  var experienceList = Rx<List<ExperienceModel?>>([]);

  var experienceJobTitle = Rx<String?>(null);
  var experienceProject = Rx<String?>(null);
  var experienceLevel = Rx<String?>(null);
  var experienceFromDate = Rx<String?>(null);
  var experienceToDate = Rx<String?>(null);
  var experienceIsCurrentlyWorkHere = false.obs;
  var experienceDescription = Rx<String?>(null);

  Future<void> fetchExperience() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-experience?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        experienceList.value = responseData
            .map<ExperienceModel?>((item) => ExperienceModel.fromJson(item))
            .toList();

        // Update the Rx variable
        experienceList.refresh();

        print(experienceList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addExperience() async {
    var requestData = {
      "id": userController.user.value?.id,
      "experience_title": experienceJobTitle.value,
      "experience_company": experienceProject.value,
      "experience_level": experienceLevel.value,
      "experience_from": experienceFromDate.value,
      "experience_to": experienceToDate.value,
      "experience_currently_working": experienceIsCurrentlyWorkHere.value,
      "experience_description": experienceDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-experience'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Experience added");
        fetchExperience();
        Get.back();
      } else {
        String errorMessage = "Failed to add Experience";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updateExperience(int idProject) async {
    var requestData = {
      "experience_id": idProject,
      "id": userController.user.value?.id,
      "experience_title": experienceJobTitle.value,
      "experience_company": experienceProject.value,
      "experience_level": experienceLevel.value,
      "experience_from": experienceFromDate.value,
      "experience_to": experienceToDate.value,
      "experience_currently_working": experienceIsCurrentlyWorkHere.value,
      "experience_description": experienceDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-experience'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Experience added");
        fetchExperience();
        Get.back();
      } else {
        String errorMessage = "Failed to add Experience";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteExperience(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-experience?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchExperience();
        showSuccessToast("Success: Delete Experience");
      } else {
        showErrorToast("Failed: Delete Experience");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> fetchProjectList() async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/list-specialization',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;
        print(responseData);

        // Simpan data specialization
        projectList.value = responseData
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ EDUCATION ++

  */

  final degreeList = Rx<List<Map<String, dynamic>>>([]);

  var educationList = Rx<List<EducationModel?>>([]);

  var educationInstitute = Rx<String?>(null);
  var educationDepartment = Rx<String?>(null);
  var educationMajor = Rx<String?>(null);
  var educationDegree = Rx<String?>(null);
  var educationFromDate = Rx<String?>(null);
  var educationToDate = Rx<String?>(null);
  var isStillStudy = false.obs;
  var educationDescription = Rx<String?>(null);

  Future<void> fetchEducation() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-education?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        educationList.value = responseData
            .map<EducationModel?>((item) => EducationModel.fromJson(item))
            .toList();

        // Update the Rx variable
        educationList.refresh();

        print(educationList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addEducation() async {
    var requestData = {
      "id": userController.user.value?.id,
      "education_name": educationInstitute.value,
      "education_department": educationDepartment.value,
      "education_major": educationMajor.value,
      "education_degree": educationDegree.value,
      "education_from": educationFromDate.value,
      "education_to": educationToDate.value,
      "education_currently_working": isStillStudy.value,
      "education_description": educationDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-education'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Education added");
        fetchEducation();
        Get.back();
      } else {
        String errorMessage = "Failed to add Education";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updateEducation(int idEducation) async {
    var requestData = {
      "id": userController.user.value?.id,
      "education_id": idEducation,
      "education_name": educationInstitute.value,
      "education_department": educationDepartment.value,
      "education_major": educationMajor.value,
      "education_degree": educationDegree.value,
      "education_from": educationFromDate.value,
      "education_to": educationToDate.value,
      "education_currently_working": isStillStudy.value,
      "education_description": educationDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-education'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Education added");
        fetchEducation();
        Get.back();
      } else {
        String errorMessage = "Failed to add Education";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteEducation(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-education?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchEducation();
        showSuccessToast("Success: Delete Education");
      } else {
        showErrorToast("Failed: Delete Education");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ CERTIFICATION ++

  */

  var certificationList = Rx<List<CertificationModel?>>([]);

  var certificationName = Rx<String?>(null);
  var certificationLink = Rx<String?>(null);
  var certificationInstitution = Rx<String?>(null);
  var certificationFromDate = Rx<String?>(null);
  var certificationToDate = Rx<String?>(null);
  var isNoExpiration = false.obs;
  var certificationDescription = Rx<String?>(null);

  Future<void> fetchCertification() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-certification?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        certificationList.value = responseData
            .map<CertificationModel?>(
                (item) => CertificationModel.fromJson(item))
            .toList();

        // Update the Rx variable
        certificationList.refresh();

        print(certificationList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addCertification() async {
    var requestData = {
      "id": userController.user.value?.id,
      "certification_name": certificationName.value,
      "certification_institution_name": certificationInstitution.value,
      "certification_link": certificationLink.value,
      "certification_from": certificationFromDate.value,
      "certification_to": certificationToDate.value,
      "certification_currently_working": isNoExpiration.value,
      "certification_description": certificationDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-certification'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: New Certification added");
        fetchCertification();
        Get.back();
      } else {
        String errorMessage = "Failed to add Certification";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updateCertification(int idCertification) async {
    var requestData = {
      "certification_id": idCertification,
      "id": userController.user.value?.id,
      "certification_name": certificationName.value,
      "certification_institution_name": certificationInstitution.value,
      "certification_link": certificationLink.value,
      "certification_from": certificationFromDate.value,
      "certification_to": certificationToDate.value,
      "certification_currently_working": isNoExpiration.value,
      "certification_description": certificationDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-certification'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Certification updated");
        fetchCertification();
        Get.back();
      } else {
        String errorMessage = "Failed to add Certification";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteCertification(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-certification?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchCertification();
        showSuccessToast("Success: Delete Certification");
      } else {
        showErrorToast("Failed: Delete Certification");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ ORGANIZATION ++

  */

  var organizationList = Rx<List<OrganizationModel?>>([]);

  var organizationName = Rx<String?>(null);
  var organizationPosition = Rx<String?>(null);
  var organizationFromDate = Rx<String?>(null);
  var organizationToDate = Rx<String?>(null);
  var isStillActive = false.obs;
  var organizationDescription = Rx<String?>(null);

  Future<void> fetchOrganization() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-organization?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        organizationList.value = responseData
            .map<OrganizationModel?>((item) => OrganizationModel.fromJson(item))
            .toList();

        // Update the Rx variable
        organizationList.refresh();

        print(organizationList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addOrganization() async {
    var requestData = {
      "id": userController.user.value?.id,
      "organization_name": organizationName.value,
      "organization_level": organizationPosition.value,
      "organization_from": organizationFromDate.value,
      "organization_to": organizationToDate.value,
      "organization_currently_working": isStillActive.value,
      "organization_description": organizationDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-organization'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: New Organization added");
        fetchOrganization();
        Get.back();
      } else {
        String errorMessage = "Failed to add Organization";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updateOrganization(int idOrganization) async {
    var requestData = {
      "organization_id": idOrganization,
      "id": userController.user.value?.id,
      "organization_name": organizationName.value,
      "organization_level": organizationPosition.value,
      "organization_from": organizationFromDate.value,
      "organization_to": organizationToDate.value,
      "organization_currently_working": isStillActive.value,
      "organization_description": organizationDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-organization'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Organization updated");
        fetchOrganization();
        Get.back();
      } else {
        String errorMessage = "Failed to updated Organization";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-organization?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchOrganization();
        showSuccessToast("Success: Delete Organization");
      } else {
        showErrorToast("Failed: Delete Organization");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ ACHIEVEMENT ++

  */

  var achievementList = Rx<List<AchievementModel?>>([]);

  var achievementName = Rx<String?>(null);
  var achievementYear = Rx<String?>(null);
  var achievementInstitute = Rx<String?>(null);
  var achievementDescription = Rx<String?>(null);

  Future<void> fetchAchievement() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-achievement?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        achievementList.value = responseData
            .map<AchievementModel?>((item) => AchievementModel.fromJson(item))
            .toList();

        // Update the Rx variable
        organizationList.refresh();

        print(organizationList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addAchievement() async {
    var requestData = {
      "id": userController.user.value?.id,
      "achievement_name": achievementName.value,
      "achievement_institution_name": achievementInstitute.value,
      "achievement_date": achievementYear.value,
      "achievement_description": achievementDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-achievement'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: New Achievement added");
        fetchAchievement();
        Get.back();
      } else {
        String errorMessage = "Failed to add Achievement";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updateAchievement(int idAchievement) async {
    var requestData = {
      "achievement_id": idAchievement,
      "id": userController.user.value?.id,
      "achievement_name": achievementName.value,
      "achievement_institution_name": achievementInstitute.value,
      "achievement_date": achievementYear.value,
      "achievement_description": achievementDescription.value,
    };

    // Convert the requestData to JSON format
    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      // Perform the POST request
      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-achievement'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        showSuccessToast("Success: Achievement updated");
        fetchAchievement();
        Get.back();
      } else {
        String errorMessage = "Failed to updated Achievement";

        // Attempt to parse the error message from the response body
        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {
          // Handle any parsing errors
        }

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteAchievement(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      // untuk Filter Status
      final response = await dio.delete(
        '$baseUrl/profile/delete-achievement?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchAchievement();
        showSuccessToast("Success: Delete Achievement");
      } else {
        showErrorToast("Failed: Delete Achievement");
      }

      // Untuk Filter Client Source
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ VOLUNTEER ++

  */

  var volunteerList = Rx<List<VolunteerModel?>>([]);

  var volunteerName = Rx<String?>(null);
  var volunteerPosition = Rx<String?>(null);
  var volunteerDivision = Rx<String?>(null);
  var volunteerFromDate = Rx<String?>(null);
  var volunteerToDate = Rx<String?>(null);
  var isStillActiveVolunteer = false.obs;
  var volunteerDescription = Rx<String?>(null);

  Future<void> fetchVolunteer() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-volunteer?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        volunteerList.value = responseData
            .map<VolunteerModel?>((item) => VolunteerModel.fromJson(item))
            .toList();

        // Update the Rx variable
        volunteerList.refresh();

        print(volunteerList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addVolunteer() async {
    var requestData = {
      "id": userController.user.value?.id,
      "volunteer_name": volunteerName.value,
      "volunteer_level": volunteerPosition.value,
      "division": volunteerDivision.value,
      "volunteer_from": volunteerFromDate.value,
      "volunteer_to": volunteerToDate.value,
      "volunteer_currently_working": isStillActiveVolunteer.value,
      "volunteer_description": volunteerDescription.value,
    };

    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-volunteer'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Volunteer added");
        fetchVolunteer();
        Get.back();
      } else {
        String errorMessage = "Failed to add Volunteer";

        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {}

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updateVolunteer(int idVolunteer) async {
    var requestData = {
      "volunteer_id": idVolunteer,
      "id": userController.user.value?.id,
      "volunteer_name": volunteerName.value,
      "volunteer_level": volunteerPosition.value,
      "division": volunteerDivision.value,
      "volunteer_from": volunteerFromDate.value,
      "volunteer_to": volunteerToDate.value,
      "volunteer_currently_working": isStillActiveVolunteer.value,
      "volunteer_description": volunteerDescription.value,
    };

    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-volunteer'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Volunteer updated");
        fetchVolunteer();
        Get.back();
      } else {
        String errorMessage = "Failed to updated Volunteer";

        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {}

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deleteVolunteer(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-volunteer?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchVolunteer();
        showSuccessToast("Success: Delete Volunteer");
      } else {
        showErrorToast("Failed: Delete Volunteer");
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ PUBLICATION ++

  */

  var publicationList = Rx<List<PublicationModel?>>([]);

  var publicationTitle = Rx<String?>(null);
  var publicationUrl = Rx<String?>(null);
  var publicationYear = Rx<String?>(null);
  var publicationDescription = Rx<String?>(null);

  Future<void> fetchPublication() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-publication?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;

        print("data: $responseData");

        // Map each JSON item to an ExperienceModel using fromJson
        publicationList.value = responseData
            .map<PublicationModel?>((item) => PublicationModel.fromJson(item))
            .toList();

        // Update the Rx variable
        publicationList.refresh();

        print(publicationList.value);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> addPublication() async {
    var requestData = {
      "id": userController.user.value?.id,
      "publication_title": publicationTitle.value,
      "publication_link": publicationUrl.value,
      "publication_date": publicationYear.value,
      "publication_description": publicationDescription.value,
    };

    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      var response = await http.post(
        Uri.parse('$baseUrl/profile/add-publication'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Publication added");
        fetchPublication();
        Get.back();
      } else {
        String errorMessage = "Failed to add Publication";

        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {}

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> updatePublication(int idPublication) async {
    var requestData = {
      "publication_id": idPublication,
      "id": userController.user.value?.id,
      "publication_title": publicationTitle.value,
      "publication_link": publicationUrl.value,
      "publication_date": publicationYear.value,
      "publication_description": publicationDescription.value,
    };

    var body = jsonEncode(requestData);

    print(body);
    try {
      String? accessToken =
          authenticationController.accesToken.value.toString();

      var response = await http.post(
        Uri.parse('$baseUrl/profile/update-publication'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Publication updated");
        fetchPublication();
        Get.back();
      } else {
        String errorMessage = "Failed to updated Publication";

        try {
          var errorData = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorData["message"] ?? errorMessage;
        } catch (e) {}

        showErrorToast(errorMessage);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }

  Future<void> deletePublication(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-publication?id=$id',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchPublication();
        showSuccessToast("Success: Delete Publication");
      } else {
        showErrorToast("Failed: Delete Publication");
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /* 
     ++ PROFILE ++

  */
  final roleList = Rx<List<Map<String, dynamic>>>([]);

  var profileUsername = Rx<String?>(null);
  var profileFullName = Rx<String?>(null);
  var profileRole = Rx<Map<String, dynamic>?>(null);
  var profileNumber = Rx<String?>(null);
  var profileLinkedin = Rx<String?>(null);
  var profileWebsite = Rx<String?>(null);
  var profileInstagram = Rx<String?>(null);
  var profileMedium = Rx<String?>(null);
  var profileQuora = Rx<String?>(null);
  var profileTiktok = Rx<String?>(null);

  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> fetchProfile() async {
    try {
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile?id=$idUser',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'];

        print("data: ${responseData['username']}");

        profileUsername.value = responseData['username'];
        profileFullName.value = responseData['name'];
        profileNumber.value = responseData['phone'];
        profileLinkedin.value = responseData['linkedin'];
        profileWebsite.value = responseData['link'];
        profileInstagram.value = responseData['instagram'];
        profileMedium.value = responseData['medium'];
        profileQuora.value = responseData['quora'];
        profileTiktok.value = responseData['tiktok'];

        int jobPositionId = int.parse(responseData['job_position']);

        Map<String, dynamic>? matchedRole = roleList.value.firstWhere(
          (role) => role['id'] == jobPositionId, 
        );

        // Set profileRole based on the matched role
        if (matchedRole != null) {
          profileRole.value = matchedRole; 
        } else {
          profileRole.value = null; 
        }

        User userData = User.fromMap(responseData);
        userController.saveUser(userData);
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> editProfile() async {
    print(profileRole.value?['id']);
    try {
      // Create FormData for sending a file
      dioPkg.FormData formData = dioPkg.FormData.fromMap({
        "name": profileUsername.value,
        "username": profileFullName.value,
        "job_position": profileRole.value?['id'],
        "phone": profileNumber.value,
        "linkedin": profileLinkedin.value,
        "instagram": profileInstagram.value,
        "quora": profileQuora.value,
        "link": profileWebsite.value,
        "medium": profileMedium.value,
        "tiktok": profileTiktok.value,
        "profile_avatar": selectedImage.value != null
            ? await dioPkg.MultipartFile.fromFile(
                selectedImage.value!.path,
                filename: selectedImage.value!.path.split('/').last,
              )
            : null,
      });

      // Access token and user ID
      String? accessToken = authenticationController.accesToken.value;
      int idUser = userController.user.value!.id;

      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      };

      // Make the POST request
      var response = await dio.post(
        '$baseUrl/profile?id=$idUser',
        data: formData,
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: update basic information in profile");
        fetchProfile();

        Get.back();
      } else {
        String errorMessage = "Failed to update basic information";
        errorMessage = response.data["message"] ?? errorMessage;
        showErrorToast(errorMessage);
        print('Response body: ${response.data}');
      }
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      print('Error fetching status data: $e');
    }
  }


  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);
      int imageSize = await imageFile.length();

      // Check if the image size is greater than 2 MB
      if (imageSize > 2 * 1024 * 1024) {
        Get.snackbar(
          "Error",
          "The image size is greater than 2 MB. Please select a smaller image.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        selectedImage.value = imageFile;
      }
    }
  }

  void addRole(Map<String, dynamic> data) {
    print("selected: $data");

    profileRole.value = data;
    print(profileRole.value);
  }

  Future<void> fetchRoleList() async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/position',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data['data'] as List;
        print(responseData);

        // Simpan data specialization
        roleList.value = responseData
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  /*

  FOR ALL
  
  */

  List<dynamic> getData(String data) {
    List result = [];

    // Debugging
    print("select: ${data}");

    if (data == "project") {
      result = projectList.value;
    } else if (data == "level") {
      result = [
        {"id": "1", "name": "Fulltime"},
        {"id": "2", "name": "Parttime"},
        {"id": "3", "name": "Freelance"},
        {"id": "4", "name": "Internship"},
      ];
    } else if (data == "degree") {
      result = [
        {"id": "1", "name": "Elementary School"},
        {"id": "2", "name": "Middle School"},
        {"id": "3", "name": "High School"},
        {"id": "4", "name": "Diploma"},
        {"id": "4", "name": "Bachelor's"},
        {"id": "4", "name": "Master's"},
        {"id": "4", "name": "Doctoral"},
      ];
    } else if (data == "role") {
      result = roleList.value;
    }
    return result;
  }
}

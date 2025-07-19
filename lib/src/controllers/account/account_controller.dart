import 'dart:convert';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:cmlabs_connect/src/models/account/achievement_model.dart';
import 'package:cmlabs_connect/src/models/account/certification_model.dart';
import 'package:cmlabs_connect/src/models/account/education_model.dart';
import 'package:cmlabs_connect/src/models/account/experience_model.dart';
import 'package:cmlabs_connect/src/models/account/organization_model.dart';
import 'package:cmlabs_connect/src/models/account/publication_model.dart';
import 'package:cmlabs_connect/src/models/user_model.dart';
import 'package:cmlabs_connect/src/models/account/volunteer_model.dart';
import 'package:cmlabs_connect/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final baseUrl = Config.baseURL;
  final http.Dio dio = http.Dio();

  @override
  void onReady() async {
    super.onReady();

    // Profile
    await fetchRoleList();
    await fetchProfile();

    // Summary
    await fetchSpecializationList();
    await fetchSummary();

    // Experience
    await fetchProjectList();
    await fetchExperience();

    // Education
    await fetchEducation();

    // Organization
    await fetchOrganization();

    // Volunteer
    await fetchVolunteer();

    // Certification
    await fetchCertification();

    // Achievement
    await fetchAchievement();

    // Publication
    await fetchPublication();
  }

  /* 
     ++ PROFILE ++
  
  */

  Rx<bool> isLoadingProfile = false.obs;
  Rx<String?> profileUsername = Rx<String?>(null);
  Rx<String?> profileFullName = Rx<String?>(null);
  Rx<Map<String, dynamic>?> profileRole = Rx<Map<String, dynamic>?>(null);
  RxList<Map<String, dynamic>> profileRoleList = RxList<Map<String, dynamic>>([]);
  Rx<String?> profileNumber = Rx<String?>(null);
  Rx<String?> profileLinkedin = Rx<String?>(null);
  Rx<String?> profileWebsite = Rx<String?>(null);
  Rx<String?> profileInstagram = Rx<String?>(null);
  Rx<String?> profileMedium = Rx<String?>(null);
  Rx<String?> profileQuora = Rx<String?>(null);
  Rx<String?> profileTiktok = Rx<String?>(null);

  Future<void> fetchProfile() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile?id=$idUser',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        String? jobPosition = data['job_position'];
        if (jobPosition != null && jobPosition.isNotEmpty) {
          String? role = getRoleName(jobPosition, profileRoleList);
          if (role == null) {
            if (data['role_name'] != null && data['role_name'].isNotEmpty) {
              userController.roleName.value = data['role_name'];
            }
          } else {
            userController.roleName.value = role;
          }

          Map<String, dynamic>? matchedRole = profileRoleList.firstWhere(
            (role) => role['id'] == int.parse(jobPosition),
            orElse: () => {},
          );

          profileRole.value = matchedRole;
        } else if (userController.roleName.value != 'User') {
          Map<String, dynamic>? matchedRole = profileRoleList.firstWhere(
            (role) => role['name'] == userController.roleName.value,
            orElse: () => {},
          );

          profileRole.value = matchedRole;
        }

        profileUsername.value = data['username'] ?? '';
        profileFullName.value = data['name'] ?? '';
        profileNumber.value = data['phone'] ?? '';
        profileLinkedin.value = data['linkedin'] ?? '';
        profileWebsite.value = data['link'] ?? '';
        profileInstagram.value = data['instagram'] ?? '';
        profileMedium.value = data['medium'] ?? '';
        profileQuora.value = data['quora'] ?? '';
        profileTiktok.value = data['tiktok'] ?? '';

        User userData = User.fromMap(data);
        userController.saveUser(userData);
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch profile'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> fetchRoleList() async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/position',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;
        profileRoleList.value = data.map((item) => {'id': item['id'], 'name': item['name']}).toList();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch role list'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> editProfile(XFile? selectedImage) async {
    isLoadingProfile(true);

    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final formData = http.FormData.fromMap({
        "name": profileFullName.value,
        "username": profileUsername.value,
        "job_position": profileRole.value?['id'],
        "phone": profileNumber.value,
        "linkedin": profileLinkedin.value,
        "instagram": profileInstagram.value,
        "quora": profileQuora.value,
        "link": profileWebsite.value,
        "medium": profileMedium.value,
        "tiktok": profileTiktok.value,
        "profile_avatar": selectedImage != null
            ? await http.MultipartFile.fromFile(
                selectedImage.path,
                filename: selectedImage.path.split('/').last,
              )
            : null,
      });

      final response = await dio.post(
        '$baseUrl/profile?id=$idUser',
        options: http.Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        await fetchProfile();

        showSuccessToast("Success: update basic information in profile");
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update profile'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingProfile(false);
    }
  }

  String? getRoleName(String? jobPositionId, List<Map<String, dynamic>> roles) {
    if (jobPositionId == null) return null;

    final matchedRole = roles.firstWhere(
      (role) => role['id'].toString() == jobPositionId,
      orElse: () => {},
    );

    return matchedRole != {} ? matchedRole['name'] : null;
  }

  /* 
     ++ SUMMARY ++
  
  */

  Rx<bool> isLoadingSummary = false.obs;
  Rx<String?> summaryAbout = Rx<String?>(null);
  RxList<String?> summarySpecialization = RxList<String?>([]);
  RxList<Map<String, dynamic>> summarySpecializationList = RxList<Map<String, dynamic>>([]);
  RxList<bool> summarySpecializationChecked = <bool>[].obs;

  Future<void> fetchSpecializationList() async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/list-specialization',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        summarySpecializationList.value = data
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();

        summarySpecializationChecked.value = List<bool>.filled(summarySpecializationList.length, false);
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch specialization list'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> fetchSummary() async {
    isLoadingSummary(true);

    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-summary?id=$idUser',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        summaryAbout.value = data['about'];

        if (data['specialization'] != null && data['specialization'] is List) {
          final specList = List<String>.from(data['specialization']);
          summarySpecialization.value = specList;
          summarySpecializationChecked.value = List<bool>.filled(summarySpecializationList.length, false);

          for (int i = 0; i < summarySpecialization.length; i++) {
            final specializationName = summarySpecialization[i];

            for (int j = 0; j < summarySpecializationList.length; j++) {
              if (specializationName == summarySpecializationList[j]['name']) {
                summarySpecializationChecked[j] = true;
              }
            }
          }
        } else {
          summarySpecialization.value = [];
          summarySpecializationChecked.value = List<bool>.filled(summarySpecializationList.length, false);
        }
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch summary'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingSummary(false);
    }
  }

  Future<void> deleteSummary() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.delete(
        '$baseUrl/profile/delete-summary?id=$idUser',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        summaryAbout.value = null;
        summarySpecialization.clear();
        fetchSummary();

        showSuccessToast("Success: Delete Summary");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete summary'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Summary");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addSumary() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final data = {
        "id": idUser,
        "about": summaryAbout.value,
        "specialization": summarySpecialization,
      };

      final response = await dio.post(
        '$baseUrl/profile/update-summary',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchSummary();
        showSuccessToast("Success: add Summary");
        Get.back();
      } else {
        showErrorToast("Failed: add Summary");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to add summary'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  /* 
     ++ EXPERIENCE ++

  */

  Rx<bool> isLoadingExperience = false.obs;
  RxList<ExperienceModel?> experienceList = RxList<ExperienceModel?>([]);
  Rx<String?> experienceJobTitle = Rx<String?>(null);
  RxList<Map<String, dynamic>> experienceProjectList = RxList<Map<String, dynamic>>([]);
  Rx<String?> experienceProject = Rx<String?>(null);
  Rx<String?> experienceLevel = Rx<String?>(null);
  Rx<String?> experienceFromDate = Rx<String?>(null);
  Rx<String?> experienceToDate = Rx<String?>(null);
  Rx<bool> experienceIsCurrentlyWorkHere = false.obs;
  Rx<String?> experienceDescription = Rx<String?>(null);

  Future<void> fetchProjectList() async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/profile/list-specialization',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        experienceProjectList.value = data
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch project list'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> fetchExperience() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value!.id;

      final response = await dio.get(
        '$baseUrl/profile/get-experience?id=$idUser',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        experienceList.value = data.map<ExperienceModel?>((item) => ExperienceModel.fromJson(item)).toList();
        experienceList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch experience'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addExperience() async {
    isLoadingExperience(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-experience',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": userController.user.value?.id,
          "experience_title": experienceJobTitle.value,
          "experience_company": experienceProject.value,
          "experience_level": experienceLevel.value,
          "experience_from": experienceFromDate.value,
          "experience_to": experienceToDate.value,
          "experience_currently_working": experienceIsCurrentlyWorkHere.value,
          "experience_description": experienceDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Experience added");
        fetchExperience();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to add experience'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingExperience(false);
    }
  }

  Future<void> updateExperience(int idProject) async {
    isLoadingExperience(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-experience',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "experience_id": idProject,
          "id": userController.user.value?.id,
          "experience_title": experienceJobTitle.value,
          "experience_company": experienceProject.value,
          "experience_level": experienceLevel.value,
          "experience_from": experienceFromDate.value,
          "experience_to": experienceToDate.value,
          "experience_currently_working": experienceIsCurrentlyWorkHere.value,
          "experience_description": experienceDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Experience updated");
        fetchExperience();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update experience'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingExperience(false);
    }
  }

  Future<void> deleteExperience(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-experience?id=$id',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchExperience();
        showSuccessToast("Success: Delete Experience");
      } else {
        showErrorToast("Failed: Delete Experience");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete experience'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearExperience() {
    experienceJobTitle.value = null;
    experienceProject.value = null;
    experienceLevel.value = null;
    experienceFromDate.value = null;
    experienceToDate.value = null;
  }

  /* 
     ++ EDUCATION ++

  */

  Rx<bool> isLoadingEducation = false.obs;
  RxList<EducationModel?> educationList = RxList<EducationModel?>([]);
  Rx<String?> educationInstitute = Rx<String?>(null);
  Rx<String?> educationDepartment = Rx<String?>(null);
  Rx<String?> educationMajor = Rx<String?>(null);
  Rx<String?> educationDegree = Rx<String?>(null);
  Rx<String?> educationFromDate = Rx<String?>(null);
  Rx<String?> educationToDate = Rx<String?>(null);
  Rx<bool> educationIsStillStudy = false.obs;
  Rx<String?> educationDescription = Rx<String?>(null);

  Future<void> fetchEducation() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-education?id=$idUser',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        educationList.value = data.map<EducationModel?>((item) => EducationModel.fromJson(item)).toList();
        educationList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch education'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addEducation() async {
    isLoadingEducation(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-education',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "id": userController.user.value?.id,
          "education_name": educationInstitute.value,
          "education_department": educationDepartment.value,
          "education_major": educationMajor.value,
          "education_degree": educationDegree.value,
          "education_from": educationFromDate.value,
          "education_to": educationToDate.value,
          "education_currently_working": educationIsStillStudy.value,
          "education_description": educationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Education added");
        fetchEducation();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to add education'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingEducation(false);
    }
  }

  Future<void> updateEducation(int idEducation) async {
    isLoadingEducation(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-education',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "id": userController.user.value?.id,
          "education_id": idEducation,
          "education_name": educationInstitute.value,
          "education_department": educationDepartment.value,
          "education_major": educationMajor.value,
          "education_degree": educationDegree.value,
          "education_from": educationFromDate.value,
          "education_to": educationToDate.value,
          "education_currently_working": educationIsStillStudy.value,
          "education_description": educationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Education updated");
        fetchEducation();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update education'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingEducation(false);
    }
  }

  Future<void> deleteEducation(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-education?id=$id',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchEducation();
        showSuccessToast("Success: Delete Education");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete education'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Education");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearEducation() {
    educationInstitute.value = null;
    educationDepartment.value = null;
    educationMajor.value = null;
    educationDegree.value = null;
    educationFromDate.value = null;
    educationToDate.value = null;
    educationIsStillStudy.value = false;
    educationDescription.value = null;
  }

  /* 
     ++ ORGANIZATION ++

  */

  Rx<bool> isLoadingOrganization = false.obs;
  RxList<OrganizationModel?> organizationList = RxList<OrganizationModel?>([]);
  Rx<String?> organizationName = Rx<String?>(null);
  Rx<String?> organizationPosition = Rx<String?>(null);
  Rx<String?> organizationFromDate = Rx<String?>(null);
  Rx<String?> organizationToDate = Rx<String?>(null);
  Rx<bool> organizationIsStillActive = false.obs;
  Rx<String?> organizationDescription = Rx<String?>(null);

  Future<void> fetchOrganization() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-organization?id=$idUser',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        organizationList.value = data.map<OrganizationModel?>((item) => OrganizationModel.fromJson(item)).toList();
        organizationList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch organization'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addOrganization() async {
    isLoadingOrganization(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-organization',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": userController.user.value?.id,
          "organization_name": organizationName.value,
          "organization_level": organizationPosition.value,
          "organization_from": organizationFromDate.value,
          if (organizationIsStillActive.isFalse) "organization_to": organizationToDate.value,
          "organization_currently_working": organizationIsStillActive.value,
          "organization_description": organizationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Organization added");
        fetchOrganization();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response} ${e.response?.data['message'] ?? 'Failed to add organization'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingOrganization(false);
    }
  }

  Future<void> updateOrganization(int idOrganization) async {
    isLoadingOrganization(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-organization',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "organization_id": idOrganization,
          "id": userController.user.value?.id,
          "organization_name": organizationName.value,
          "organization_level": organizationPosition.value,
          "organization_from": organizationFromDate.value,
          if (organizationIsStillActive.isFalse) "organization_to": organizationToDate.value,
          "organization_currently_working": organizationIsStillActive.value,
          "organization_description": organizationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Organization updated");
        fetchOrganization();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update organization'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingOrganization(false);
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-organization?id=$id',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchOrganization();
        showSuccessToast("Success: Delete Organization");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete organization'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Organization");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearOrganization() {
    organizationName.value = null;
    organizationPosition.value = null;
    organizationFromDate.value = null;
    organizationToDate.value = null;
    organizationIsStillActive.value = false;
    organizationDescription.value = null;
  }

  /* 
     ++ VOLUNTEER ++

  */

  Rx<bool> isLoadingVolunteer = false.obs;
  RxList<VolunteerModel?> volunteerList = RxList<VolunteerModel?>([]);
  Rx<String?> volunteerName = Rx<String?>(null);
  Rx<String?> volunteerPosition = Rx<String?>(null);
  Rx<String?> volunteerDivision = Rx<String?>(null);
  Rx<String?> volunteerFromDate = Rx<String?>(null);
  Rx<String?> volunteerToDate = Rx<String?>(null);
  Rx<bool> volunteerIsStillActive = false.obs;
  Rx<String?> volunteerDescription = Rx<String?>(null);

  Future<void> fetchVolunteer() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-volunteer?id=$idUser',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        volunteerList.value = data.map<VolunteerModel?>((item) => VolunteerModel.fromJson(item)).toList();
        volunteerList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch volunteer'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addVolunteer() async {
    isLoadingVolunteer(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-volunteer',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": userController.user.value?.id,
          "volunteer_name": volunteerName.value,
          "volunteer_level": volunteerPosition.value,
          "division": volunteerDivision.value,
          "volunteer_from": volunteerFromDate.value,
          "volunteer_to": volunteerToDate.value,
          "volunteer_currently_working": volunteerIsStillActive.value,
          "volunteer_description": volunteerDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Volunteer added");
        fetchVolunteer();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to add volunteer'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingVolunteer(false);
    }
  }

  Future<void> updateVolunteer(int idVolunteer) async {
    isLoadingVolunteer(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-volunteer',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "volunteer_id": idVolunteer,
          "id": userController.user.value?.id,
          "volunteer_name": volunteerName.value,
          "volunteer_level": volunteerPosition.value,
          "division": volunteerDivision.value,
          "volunteer_from": volunteerFromDate.value,
          "volunteer_to": volunteerToDate.value,
          "volunteer_currently_working": volunteerIsStillActive.value,
          "volunteer_description": volunteerDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Volunteer updated");
        fetchVolunteer();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update volunteer'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingVolunteer(false);
    }
  }

  Future<void> deleteVolunteer(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-volunteer?id=$id',
        options: http.Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchVolunteer();
        showSuccessToast("Success: Delete Volunteer");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete volunteer'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Volunteer");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearVolunteer() {
    volunteerName.value = null;
    volunteerPosition.value = null;
    volunteerDivision.value = null;
    volunteerFromDate.value = null;
    volunteerToDate.value = null;
    volunteerIsStillActive.value = false;
    volunteerDescription.value = null;
  }

  /* 
     ++ CERTIFICATION ++

  */

  Rx<bool> isLoadingCertification = false.obs;
  RxList<CertificationModel?> certificationList = RxList<CertificationModel?>([]);
  Rx<String?> certificationName = Rx<String?>(null);
  Rx<String?> certificationLink = Rx<String?>(null);
  Rx<String?> certificationInstitution = Rx<String?>(null);
  Rx<String?> certificationFromDate = Rx<String?>(null);
  Rx<String?> certificationToDate = Rx<String?>(null);
  Rx<bool> certificationIsNoExpiration = false.obs;
  Rx<String?> certificationDescription = Rx<String?>(null);

  Future<void> fetchCertification() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-certification?id=$idUser',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        certificationList.value = data.map<CertificationModel?>((item) => CertificationModel.fromJson(item)).toList();
        certificationList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch certification'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addCertification() async {
    isLoadingCertification(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-certification',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": userController.user.value?.id,
          "certification_name": certificationName.value,
          "certification_institution_name": certificationInstitution.value,
          "certification_link": certificationLink.value,
          "certification_from": certificationFromDate.value,
          "certification_to": certificationToDate.value,
          "certification_currently_working": certificationIsNoExpiration.value,
          "certification_description": certificationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Certification added");
        fetchCertification();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message']}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingCertification(false);
    }
  }

  Future<void> updateCertification(int idCertification) async {
    isLoadingCertification(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-certification',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "certification_id": idCertification,
          "id": userController.user.value?.id,
          "certification_name": certificationName.value,
          "certification_institution_name": certificationInstitution.value,
          "certification_link": certificationLink.value,
          "certification_from": certificationFromDate.value,
          "certification_to": certificationToDate.value,
          "certification_currently_working": certificationIsNoExpiration.value,
          "certification_description": certificationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Certification updated");
        fetchCertification();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update certification'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingCertification(false);
    }
  }

  Future<void> deleteCertification(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-certification?id=$id',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchCertification();
        showSuccessToast("Success: Delete Certification");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete certification'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Certification");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearCertification() {
    certificationName.value = null;
    certificationInstitution.value = null;
    certificationLink.value = null;
    certificationFromDate.value = null;
    certificationToDate.value = null;
    certificationIsNoExpiration.value = false;
    certificationDescription.value = null;
  }

  /* 
     ++ ACHIEVEMENT ++

  */

  Rx<bool> isLoadingAchievement = false.obs;
  RxList<AchievementModel?> achievementList = RxList<AchievementModel?>([]);
  Rx<String?> achievementName = Rx<String?>(null);
  Rx<String?> achievementYear = Rx<String?>(null);
  Rx<String?> achievementInstitute = Rx<String?>(null);
  Rx<String?> achievementDescription = Rx<String?>(null);

  Future<void> fetchAchievement() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-achievement?id=$idUser',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        achievementList.value = data.map<AchievementModel?>((item) => AchievementModel.fromJson(item)).toList();
        achievementList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch achievement'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addAchievement() async {
    isLoadingAchievement(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-achievement',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": userController.user.value?.id,
          "achievement_name": achievementName.value,
          "achievement_institution_name": achievementInstitute.value,
          "achievement_date": achievementYear.value,
          "achievement_description": achievementDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Achievement added");
        fetchAchievement();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to add achievement'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingAchievement(false);
    }
  }

  Future<void> updateAchievement(int idAchievement) async {
    isLoadingAchievement(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-achievement',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "achievement_id": idAchievement,
          "id": userController.user.value?.id,
          "achievement_name": achievementName.value,
          "achievement_institution_name": achievementInstitute.value,
          "achievement_date": achievementYear.value,
          "achievement_description": achievementDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Achievement updated");
        fetchAchievement();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update achievement'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingAchievement(false);
    }
  }

  Future<void> deleteAchievement(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-achievement?id=$id',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchAchievement();
        showSuccessToast("Success: Delete Achievement");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete achievement'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Achievement");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearAchievement() {
    achievementName.value = null;
    achievementYear.value = null;
    achievementInstitute.value = null;
    achievementDescription.value = null;
  }

  /* 
     ++ PUBLICATION ++

  */

  Rx<bool> isLoadingPublication = false.obs;
  RxList<PublicationModel?> publicationList = RxList<PublicationModel?>([]);
  Rx<String?> publicationTitle = Rx<String?>(null);
  Rx<String?> publicationUrl = Rx<String?>(null);
  Rx<String?> publicationYear = Rx<String?>(null);
  Rx<String?> publicationDescription = Rx<String?>(null);

  Future<void> fetchPublication() async {
    try {
      String? accessToken = userController.accesToken.value;
      int idUser = userController.user.value?.id ?? 0;

      final response = await dio.get(
        '$baseUrl/profile/get-publication?id=$idUser',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;

        publicationList.value = data.map<PublicationModel?>((item) => PublicationModel.fromJson(item)).toList();
        publicationList.refresh();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to fetch publication'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    }
  }

  Future<void> addPublication() async {
    isLoadingPublication(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/add-publication',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": userController.user.value?.id,
          "publication_title": publicationTitle.value,
          "publication_link": publicationUrl.value,
          "publication_date": publicationYear.value,
          "publication_description": publicationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: New Publication added");
        fetchPublication();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to add publication'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingPublication(false);
    }
  }

  Future<void> updatePublication(int idPublication) async {
    isLoadingPublication(true);

    try {
      String? accessToken = userController.accesToken.value.toString();

      final response = await dio.post(
        '$baseUrl/profile/update-publication',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "publication_id": idPublication,
          "id": userController.user.value?.id,
          "publication_title": publicationTitle.value,
          "publication_link": publicationUrl.value,
          "publication_date": publicationYear.value,
          "publication_description": publicationDescription.value,
        },
      );

      if (response.statusCode == 200) {
        showSuccessToast("Success: Publication updated");
        fetchPublication();
        Get.back();
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to update publication'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Error: An unexpected error occurred.");
      debugPrint('Error fetching status data: $e');
    } finally {
      isLoadingPublication(false);
    }
  }

  Future<void> deletePublication(int id) async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.delete(
        '$baseUrl/profile/delete-publication?id=$id',
        options: http.Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        fetchPublication();
        showSuccessToast("Success: Delete Publication");
      }
    } on http.DioException catch (e) {
      showErrorToast("Error: ${e.response?.data['message'] ?? 'Failed to delete publication'}");
      debugPrint('Error: ${e.response?.data['message']}');
    } catch (e) {
      showErrorToast("Failed: Delete Publication");
      debugPrint('Error fetching status data: $e');
    }
  }

  void clearPublication() {
    publicationTitle.value = null;
    publicationUrl.value = null;
    publicationYear.value = null;
    publicationDescription.value = null;
  }

  /*

  FOR ALL
  
  */

  List<dynamic> getData(AccountSelectData data) {
    switch (data) {
      case AccountSelectData.project:
        return experienceProjectList;
      case AccountSelectData.level:
        return [
          {"id": "1", "name": "Fulltime"},
          {"id": "2", "name": "Parttime"},
          {"id": "3", "name": "Freelance"},
          {"id": "4", "name": "Internship"},
        ];
      case AccountSelectData.degree:
        return [
          {"id": "1", "name": "Elementary School"},
          {"id": "2", "name": "Middle School"},
          {"id": "3", "name": "High School"},
          {"id": "4", "name": "Diploma"},
          {"id": "4", "name": "Bachelor's"},
          {"id": "4", "name": "Master's"},
          {"id": "4", "name": "Doctoral"},
        ];
      case AccountSelectData.role:
        return profileRoleList;
    }
  }

  void setValue({
    required AccountSelectData data,
    required Map<String, dynamic>? value,
  }) {
    switch (data) {
      case AccountSelectData.role:
        profileRole.value = value;
        break;
      case AccountSelectData.project:
        experienceProject.value = value?['name'];
        break;
      case AccountSelectData.level:
        experienceLevel.value = value?['name'];
        break;
      case AccountSelectData.degree:
        educationDegree.value = value?['name'];
        break;
    }
  }
}

enum AccountSelectData { project, level, degree, role }

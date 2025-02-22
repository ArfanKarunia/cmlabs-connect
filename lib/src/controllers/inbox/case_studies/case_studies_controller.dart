import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/case_studies_model.dart';
import '../inbox_controller.dart';
import '../../user/user_controller.dart';

class CaseStudiesController extends InboxController {
  RxList<CaseStudies> caseStudiesList = <CaseStudies>[].obs;

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final UserController userController = Get.find<UserController>();

  @override
  Future<void> fetchList({
    bool isLoadMore = false,
    bool refreshData = false,
  }) async {
    try {
      String? accessToken = userController.accesToken.value;

      if (refreshData) {
        start.value = 0;
        limit.value = caseStudiesList.isNotEmpty ? caseStudiesList.length : 10;
      }

      if (!isLoadMore && !refreshData) {
        start.value = 0;
        limit.value = 10;
      }

      String url = constructFilteredUrl('$baseUrl/case-studies/index');

      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<CaseStudies> caseStudies = rawData.map<CaseStudies>((item) {
            return CaseStudies.fromJson(item);
          }).toList();

          if (isLoadMore) {
            caseStudiesList.addAll(caseStudies);
          } else {
            caseStudiesList.value = caseStudies;
          }

          if (refreshData) limit.value = 10;
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Future<void> resetList() async {
    start.value = 0;
    caseStudiesList.clear();

    clearAll();
    await fetchList();
  }

  @override
  Future<void> deleteData(int? id) async {
    if (id == null) return;
  }

  List<CaseStudies> get filteredCaseStudies {
    List<CaseStudies> result = List.from(caseStudiesList);

    // Jika search tidak kosong, lakukan pencarian berdasarkan nama atau field lain
    // Filter berdasarkan pencarian (search) jika search tidak kosong
    if (search.value != null && search.value!.isNotEmpty) {
      final query = search.value!.toLowerCase();

      result = result.where((caseStudies) {
        return ((caseStudies.email ?? '').toLowerCase().contains(query)) ||
            (caseStudies.section?.toLowerCase().contains(query) ?? false) ||
            (caseStudies.data?.company?.toLowerCase().contains(query) ?? false) ||
            (caseStudies.data?.name?.toLowerCase().contains(query) ?? false) ||
            (caseStudies.data?.category?.toLowerCase().contains(query) ?? false);
        // || (caseStudies.data.clientSource?.value?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }
}

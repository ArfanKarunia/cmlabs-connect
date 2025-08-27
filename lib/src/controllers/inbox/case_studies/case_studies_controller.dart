import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/inbox/case_studies_model.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/toast.dart';
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
        isLoading(true);
        await Future.delayed(Durations.short2);

        start.value = 0;
        limit.value = 10;
      }

      String url = constructFilteredUrl('$baseUrl/case-studies/index');

      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (!isLoadMore) {
          final res = response.data['total'];
          totalLeads.value = res;
        }

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
    } catch (_) {
    } finally {
      if (!isLoadMore) isLoading(false);
    }
  }

  @override
  Future<void> exportData() async {
    try {
      String? accessToken = userController.accesToken.value;

      await PermissionUtils().requestStoragePermission();

      isExportLoading(true);

      final response = await dio.get(
        constructExportUrl('$baseUrl/case-studies/export-excel', feature: 'case-study'),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final fileName = FileUtils.getFilenameFromResponse(response);
        final filePath = await FileUtils.saveFile(response.data, fileName);

        showSuccessToast('Data tersimpan di $filePath');
        FileUtils.openFile(filePath);
      }
    } on DioException catch (e) {
      showErrorToast('Failed to export data: ${e.message}');
    } catch (e) {
      showErrorToast('Failed to export data: ${e.toString()}');
    } finally {
      isExportLoading(false);
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
    try {
      final accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty || id == null) {
        showErrorToast('Gagal menghapus Case Study');
      }

      final response = await dio.delete(
        '$baseUrl/case-studies/delete-case-study/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        caseStudiesList.removeWhere((caseStudies) => caseStudies.id == id);
        totalLeads.value -= 1;
        showSuccessToast('Berhasil menghapus Case Study');
      } else {
        showErrorToast('Gagal menghapus Case Study');
        // debugPrint("Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      // debugPrint('Error fetching data: $e');
      showErrorToast('Terjadi kesalahan saat menghapus data');
    }
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
            (caseStudies.data?.category?.any((e) => e.toLowerCase().contains(query)) ?? false) ||
            (caseStudies.data?.phoneNumber?.toLowerCase().contains(query) ?? false);
        // || (caseStudies.data.clientSource?.value?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }
}

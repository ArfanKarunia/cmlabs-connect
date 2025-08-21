import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../constant/config.dart';
import '../../../models/inbox/faq_model.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../utils/toast.dart';
import '../../user/user_controller.dart';
import '../inbox_controller.dart';

class FaqController extends InboxController {
  RxList<Faq> faqList = <Faq>[].obs;

  Rx<int> newestIdQuotation = Rx<int>(0);
  Rx<int> newQuotationCount = Rx<int>(0);

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
        limit.value = faqList.isNotEmpty ? faqList.length : 10;
      }

      if (!isLoadMore && !refreshData) {
        start.value = 0;
        limit.value = 10;
      }

      String url = constructFilteredUrl('$baseUrl/faq/index');

      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<Faq> faq = rawData.map<Faq>((item) {
            return Faq.fromJson(item);
          }).toList();

          if (isLoadMore) {
            faqList.addAll(faq);
          } else {
            faqList.value = faq;
          }

          if (refreshData) limit.value = 10;
        }
      }
    } catch (_) {}
  }

  @override
  Future<void> resetList() async {
    start.value = 0;
    faqList.clear();

    clearAll();
    await fetchList();
  }

  @override
  Future<void> fetchTotalLeads() async {
    try {
      String? accessToken = userController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/faq/count-all-faq',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        totalLeads.value = response.data['data'];
      }
    } catch (_) {}
  }

  @override
  Future<void> exportData() async {
    try {
      String? accessToken = userController.accesToken.value;

      await PermissionUtils().requestStoragePermission();

      isExportLoading(true);

      final response = await dio.get(
        constructExportUrl('$baseUrl/faq/export-excel-faq', feature: 'faq'),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final fileName = FileUtils.getFilenameFromResponse(response);
        final filePath = await FileUtils.saveFile(response.data, fileName);

        showSuccessToast('Data tersimpan di $filePath');
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
  Future<void> deleteData(int? id) async {
    try {
      final accessToken = userController.accesToken.value;
      if (accessToken == null || accessToken.isEmpty || id == null) {
        showErrorToast('Gagal menghapus Contact Us');
      }

      final response = await dio.delete(
        '$baseUrl/faq/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        faqList.removeWhere((faq) => faq.id == id);
        // totalLeads.value -= 1;
        showSuccessToast('Berhasil menghapus FAQ');
      } else {
        showErrorToast('Gagal menghapus FAQ');
        // debugPrint("Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      // debugPrint('Error fetching data: $e');
      showErrorToast('Terjadi kesalahan saat menghapus data');
    }
  }

  @override
  String constructFilteredUrl(String url) {
    String finalUrl = '$url?start=${start.value}&limit=${limit.value}';
    if (filterStatus.value != null) {
      finalUrl += '&status=${Uri.encodeComponent(filterStatus.value ?? '')}';
    }

    return finalUrl;
  }

  List<Faq> get filteredFaq {
    List<Faq> result = List.from(faqList);

    if (search.value != null && search.value!.isNotEmpty) {
      final query = search.value!.toLowerCase();

      result = result.where((faq) {
        return (faq.email?.toLowerCase().contains(query) ?? false) ||
            (faq.whatsappNumber?.toLowerCase().contains(query) ?? false) ||
            (faq.companyName?.toLowerCase().contains(query) ?? false) ||
            (faq.question?.toLowerCase().contains(query) ?? false) ||
            (faq.shortQuestion?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }
}

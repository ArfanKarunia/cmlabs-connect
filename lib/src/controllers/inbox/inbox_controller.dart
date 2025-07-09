import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/string_utils.dart';
import '../../utils/toast.dart';

abstract class InboxController extends GetxController {
  Rx<int> start = 0.obs;
  Rx<int> limit = 10.obs;
  RxList<String> filterCategory = <String>[].obs;
  Rx<String?> filterStatus = Rx<String?>(null);
  Rx<String?> filterClientSource = Rx<String?>(null);
  Rx<String?> filterPic = Rx<String?>(null);

  Rx<DateTime?> filterStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);

  Rx<String?> search = Rx<String?>(null);

  Rx<int> totalLeads = Rx<int>(0);

  Rx<bool> isExportLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchTotalLeads();
    fetchList();
    // checkNewQuotationsPeriodically();
  }

  // Inbox Data List
  Future<void> fetchList({
    bool isLoadMore = false,
    bool refreshData = false,
  });
  Future<void> resetList();
  Future<void> deleteData(int? id);
  Future<void> loadMore() async {
    start.value += limit.value;
    await fetchList(isLoadMore: true);
  }

  Future<void> exportData();

  // Total Leads
  Future<void> fetchTotalLeads();

  // Filter
  void addFilterStatus(String status) {
    filterStatus.value = status;
  }

  void clearFilterStatus() {
    filterStatus.value = null;
  }

  void addFilterClientSource(String clientSource) {
    filterClientSource.value = clientSource;
  }

  void clearFilterClientSource() {
    filterClientSource.value = null;
  }

  void addFilterPic(String pic) {
    filterPic.value = pic;
  }

  void clearFilterPic() {
    filterPic.value = null;
  }

  void addFilterCategory(String category) {
    filterCategory.add(category);
  }

  void removeFilterCategory(String category) {
    filterCategory.remove(category);
  }

  void clearFilterCategory() {
    filterCategory.clear();
  }

  void addFilterDate({DateTime? start, DateTime? end}) {
    filterStartDate.value = start ?? filterStartDate.value;
    filterEndDate.value = end ?? filterEndDate.value;
  }

  void clearFilterDate() {
    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  void addSearch(String? query) {
    search.value = query;
  }

  void clearSearch() {
    search.value = null;
  }

  void clearAll() {
    clearFilterStatus();
    clearFilterClientSource();
    clearFilterPic();
    clearFilterCategory();
    clearFilterDate();
    clearSearch();
  }

  String filterQueryString(String url) {
    // Konversi filter tanggal ke format string
    String? startDateString = filterStartDate.value != null
        ? "${filterStartDate.value!.year}-${filterStartDate.value!.month.toString().padLeft(2, '0')}-${filterStartDate.value!.day.toString().padLeft(2, '0')}"
        : null;
    String? endDateString = filterEndDate.value != null
        ? "${filterEndDate.value!.year}-${filterEndDate.value!.month.toString().padLeft(2, '0')}-${filterEndDate.value!.day.toString().padLeft(2, '0')}"
        : null;

    // Construct query parameters
    List<String> queryParams = [];

    if (startDateString != null) {
      queryParams.add('startDate=${Uri.encodeComponent(startDateString)}');
    }
    if (endDateString != null) {
      queryParams.add('endDate=${Uri.encodeComponent(endDateString)}');
    }
    if (filterPic.value != null) {
      queryParams.add('pic=${Uri.encodeComponent(StringUtils.toCamelCase(filterPic.value))}');
    }
    if (filterClientSource.value != null) {
      String params = url.contains('case-studies') ? 'client_source' : 'clientSource';
      queryParams.add('$params=${Uri.encodeComponent(StringUtils.toCamelCase(filterClientSource.value))}');
    }
    if (filterStatus.value != null) {
      queryParams.add('status=${Uri.encodeComponent(filterStatus.value!)}');
    }

    // Handle category filter with array format
    if (filterCategory.isNotEmpty) {
      queryParams.addAll(filterCategory.map((category) => 'category[]=${Uri.encodeComponent(category)}'));
    }

    // Combine all query parameters
    return queryParams.join('&');
  }

  String constructFilteredUrl(String url) {
    String queryString = filterQueryString(url);
    String finalUrl = '$url?start=${start.value}&limit=${limit.value}';
    if (queryString.isNotEmpty) {
      finalUrl += '&$queryString';
    }

    return finalUrl;
  }

  String constructExportUrl(String url, {required String feature}) {
    String queryString = filterQueryString(url);
    final finalUrl = queryString.isEmpty ? '$url?feature=$feature' : '$url?$queryString&feature=$feature';

    return finalUrl;
  }

  Future<void> redirectToWhatsapp({
    String? phoneCode,
    required String phoneNumber,
  }) async {
    if (phoneNumber.isEmpty) {
      showErrorToast('Nomor telepon tidak tersedia');
      return;
    }

    if (phoneCode == null || phoneCode.isEmpty) {
      await launchUrl(Uri.parse("https://wa.me/$phoneNumber"), mode: LaunchMode.externalApplication);
      return;
    }

    String modifiedNumber = phoneNumber;
    if (phoneNumber.startsWith('0')) {
      modifiedNumber = '$phoneCode${phoneNumber.substring(1)}';
    } else if (!(phoneNumber.startsWith(phoneCode) || phoneNumber.startsWith('+$phoneCode'))) {
      modifiedNumber = '$phoneCode$phoneNumber';
    }

    final url = Uri.parse("https://wa.me/$modifiedNumber");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

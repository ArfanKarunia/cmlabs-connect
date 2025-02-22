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

  // Total Leads
  // Future<void> fetchTotalLeads();

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

  String constructFilteredUrl(String url) {
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
    String queryString = queryParams.join('&');

    // Construct the full URL
    String finalUrl = '$url?start=${start.value}&limit=${limit.value}';
    if (queryString.isNotEmpty) {
      finalUrl += '&$queryString';
    }

    return finalUrl;
  }

  Future<void> redirectToWhatsapp({
    required String? phoneCode,
    required String? phoneNumber,
  }) async {
    if (phoneCode == null || phoneNumber == null || phoneCode.isEmpty || phoneNumber.isEmpty) {
      showErrorToast('Nomor telepon tidak tersedia');
      return;
    }

    final url = Uri.parse("https://wa.me/$phoneNumber");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

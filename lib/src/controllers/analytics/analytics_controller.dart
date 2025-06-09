import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/config.dart';
import '../user/user_controller.dart';

enum SortOption {
  newestDate,
  oldestDate,
  newMost,
  newLeast,
  acceptedMost,
  acceptedLeast,
  rejectedMost,
  rejectedLeast,
  followUpMost,
  followUpLeast,
  totalMost,
  totalLeast,
}

enum DateType { daily, weekly, monthly, yearly, custom }

enum AnalyticsType { quotationTraffic, topServices, topPICs, quotationTrends }

enum AnalyticsFilterType { category, pic, clientSource, utm, status }

class AnalyticsController extends GetxController {
  RxBool isFilterLoading = false.obs;
  Rx<SortOption?> selectedSortOption = Rx<SortOption?>(SortOption.newestDate);

  Rx<DateType?> initialDateType = (DateType.daily).obs;
  Rx<DateType?> selectedDateType = (DateType.daily).obs;

  Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);
  RxMap<String, String> selectedCategory = {'label': 'All', 'value': 'all'}.obs;
  RxMap<String, String> selectedPic = {'label': 'All', 'value': 'all'}.obs;
  RxMap<String, String> selectedClientSource = {'label': 'All', 'value': 'all'}.obs;
  RxMap<String, String> selectedUtm = {'label': 'All', 'value': 'all'}.obs;
  RxMap<String, String> selectedStatus = {'label': 'All', 'value': 'all'}.obs;

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final UserController userController = Get.find<UserController>();

  @override
  void onReady() {
    super.onReady();
    fetchData(dateType: selectedDateType.value);
  }

  Future<void> fetchData({DateType? dateType}) async {}

  String constructFilteredUrl(
    String baseUrl, {
    AnalyticsType? analyticsType,
    DateType? dateType,
  }) {
    String? startDateString = selectedStartDate.value != null
        ? "${selectedStartDate.value!.year}-${selectedStartDate.value!.month.toString().padLeft(2, '0')}-${selectedStartDate.value!.day.toString().padLeft(2, '0')}"
        : null;
    String? endDateString = selectedEndDate.value != null
        ? "${selectedEndDate.value!.year}-${selectedEndDate.value!.month.toString().padLeft(2, '0')}-${selectedEndDate.value!.day.toString().padLeft(2, '0')}"
        : null;

    List<String> queryParams = [];
    if (startDateString != null) {
      analyticsType != AnalyticsType.quotationTrends
          ? queryParams.add('start_date=${Uri.encodeComponent(startDateString)}')
          : queryParams.add(
              'start_period=${selectedStartDate.value?.year}-${selectedStartDate.value?.month.toString().padLeft(2, '0')}');
    }
    if (endDateString != null) {
      analyticsType != AnalyticsType.quotationTrends
          ? queryParams.add('end_date=${Uri.encodeComponent(endDateString)}')
          : queryParams.add(
              'end_period=${selectedEndDate.value?.year}-${selectedEndDate.value?.month.toString().padLeft(2, '0')}');
    }

    if (startDateString != null || endDateString != null) {
      queryParams.add('date_type=custom');
      selectedDateType.value = DateType.custom;
    } else {
      if (analyticsType == AnalyticsType.topPICs || analyticsType == AnalyticsType.topServices) {
        switch (dateType ?? selectedDateType.value) {
          case DateType.daily:
            queryParams.add('date_type=this_day');
            break;
          case DateType.weekly:
            queryParams.add('date_type=this_week');
            break;
          case DateType.monthly:
            queryParams.add('date_type=this_month');
            break;
          case DateType.yearly:
            queryParams.add('date_type=this_year');
            break;
          default:
            break;
        }
      } else {
        switch (dateType ?? selectedDateType.value) {
          case DateType.daily:
            queryParams.add('date_type=daily');
            break;
          case DateType.weekly:
            queryParams.add('date_type=weekly');
            break;
          case DateType.monthly:
            queryParams.add('date_type=monthly');
            break;
          case DateType.yearly:
            queryParams.add('date_type=yearly');
            break;
          default:
            break;
        }
      }
    }

    switch (selectedSortOption.value) {
      case SortOption.newestDate:
        queryParams.add('sort_by=date');
        queryParams.add('sort_order=desc');
        break;
      case SortOption.oldestDate:
        queryParams.add('sort_by=date');
        queryParams.add('sort_order=asc');
        break;
      case SortOption.newMost:
        queryParams.add('sort_by=new');
        queryParams.add('sort_order=desc');
        break;
      case SortOption.newLeast:
        queryParams.add('sort_by=new');
        queryParams.add('sort_order=asc');
        break;
      case SortOption.acceptedMost:
        queryParams.add('sort_by=accepted');
        queryParams.add('sort_order=desc');
        break;
      case SortOption.acceptedLeast:
        queryParams.add('sort_by=accepted');
        queryParams.add('sort_order=asc');
        break;
      case SortOption.rejectedMost:
        queryParams.add('sort_by=rejected');
        queryParams.add('sort_order=desc');
        break;
      case SortOption.rejectedLeast:
        queryParams.add('sort_by=rejected');
        queryParams.add('sort_order=asc');
        break;
      case SortOption.followUpMost:
        queryParams.add('sort_by=followed_up');
        queryParams.add('sort_order=desc');
        break;
      case SortOption.followUpLeast:
        queryParams.add('sort_by=followed_up');
        queryParams.add('sort_order=asc');
        break;
      case SortOption.totalMost:
        queryParams.add('sort_by=total');
        queryParams.add('sort_order=desc');
        break;
      case SortOption.totalLeast:
        queryParams.add('sort_by=total');
        queryParams.add('sort_order=asc');
        break;
      default:
        break;
    }

    if (selectedCategory['value'] != 'all') {
      queryParams.add('category[]=${selectedCategory['value']}');
    }
    if (selectedPic['value'] != 'all') {
      queryParams.add('pic=${selectedPic['value']}');
    }
    if (selectedClientSource['value'] != 'all') {
      queryParams.add('client_source=${selectedClientSource['value']}');
    }
    if (selectedUtm['value'] != 'all') {
      queryParams.add('utm[]=${selectedUtm['value']}');
    }
    if (selectedStatus['value'] != 'all') {
      queryParams.add('status=${selectedStatus['value']}');
    }

    debugPrint('$baseUrl?${queryParams.join('&')}');
    return '$baseUrl?${queryParams.join('&')}';
  }

  String getChartSubtitle(DateType dateType) {
    switch (dateType) {
      case DateType.daily:
        return 'Today';
      case DateType.weekly:
        return 'This Week';
      case DateType.monthly:
        return 'This Month';
      case DateType.yearly:
        return 'This Year';
      case DateType.custom:
        return '${selectedStartDate.value?.toLocal().toString().split(' ')[0]} - ${selectedEndDate.value?.toLocal().toString().split(' ')[0]}';
    }
  }

  List<Map<String, String>> getFilterOptions({
    required AnalyticsFilterType type,
  }) {
    switch (type) {
      case AnalyticsFilterType.category:
        return categoriesOptions;
      case AnalyticsFilterType.pic:
        return picOptions;
      case AnalyticsFilterType.clientSource:
        return clientSourceOptions;
      case AnalyticsFilterType.utm:
        return utmOptions;
      case AnalyticsFilterType.status:
        return statusOptions;
    }
  }

  Map<String, String> getSelectedFilterOption({
    required AnalyticsFilterType type,
  }) {
    switch (type) {
      case AnalyticsFilterType.category:
        return selectedCategory;
      case AnalyticsFilterType.pic:
        return selectedPic;
      case AnalyticsFilterType.clientSource:
        return selectedClientSource;
      case AnalyticsFilterType.utm:
        return selectedUtm;
      case AnalyticsFilterType.status:
        return selectedStatus;
    }
  }

  void setDateType({required DateType dateType}) {
    selectedDateType.value = dateType;
    if (dateType != DateType.custom) {
      selectedStartDate.value = null;
      selectedEndDate.value = null;
    }
    fetchData(dateType: dateType);
  }

  void setSelectedFilterOption({
    required AnalyticsFilterType type,
    required Map<String, String> option,
  }) {
    switch (type) {
      case AnalyticsFilterType.category:
        selectedCategory.value = option;
        break;
      case AnalyticsFilterType.pic:
        selectedPic.value = option;
        break;
      case AnalyticsFilterType.clientSource:
        selectedClientSource.value = option;
        break;
      case AnalyticsFilterType.utm:
        selectedUtm.value = option;
        break;
      case AnalyticsFilterType.status:
        selectedStatus.value = option;
        break;
    }
  }

  void setAnalyticsSortOption({required SortOption sortOption}) {
    selectedSortOption.value = sortOption;
    fetchData(dateType: selectedDateType.value);
  }

  Future<void> applyFilters() async {
    isFilterLoading(true);
    await fetchData(dateType: selectedDateType.value);
    isFilterLoading(false);
    Get.back();
  }

  void resetFilter() {
    selectedDateType.value = initialDateType.value;
    selectedStartDate.value = null;
    selectedEndDate.value = null;
    selectedCategory.value = {'label': 'All', 'value': 'all'};
    selectedPic.value = {'label': 'All', 'value': 'all'};
    selectedClientSource.value = {'label': 'All', 'value': 'all'};
    selectedUtm.value = {'label': 'All', 'value': 'all'};
    selectedStatus.value = {'label': 'All', 'value': 'all'};

    applyFilters();
  }

  void resetSortOption() {
    selectedSortOption.value = SortOption.newestDate;
  }
}

// Dummy Data
final List<Map<String, String>> categoriesOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'SEO Services', 'value': 'seo-services'},
  {'label': 'SEO Content Writing', 'value': 'seo-content-writing'},
  {'label': 'SEM', 'value': 'sem'},
  {'label': 'Social Media Management', 'value': 'social-media-management'},
  {'label': 'Digital Marketing', 'value': 'digital-marketing'},
];
final List<Map<String, String>> picOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'Vanessa', 'value': 'vanessa'},
  {'label': 'Larasati', 'value': 'larasati'},
  {'label': 'Agita Ayudya', 'value': 'agita_ayudya'},
  {'label': 'Bobby Pranata', 'value': 'bobby_pranata'},
  {'label': 'Arfan', 'value': 'arfan'},
  {'label': 'Naufal', 'value': 'naufal'},
  {'label': 'Pasha', 'value': 'pasha'},
];
final List<Map<String, String>> clientSourceOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'Direct Email', 'value': 'direct_email'},
  {'label': 'Web WhatsApp', 'value': 'web_whatsapp'},
  {'label': 'SEM', 'value': 'sem'},
  {'label': 'Direct LinkedIn', 'value': 'direct_linkedin'},
  {'label': 'Direct Partnership', 'value': 'direct_partnership'},
];
final List<Map<String, String>> utmOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'Google & GDN', 'value': 'Google&GDN'},
  {'label': 'Google & CPC', 'value': 'Google&CPC'},
  {'label': 'Meta & GDN', 'value': 'Meta&GDN'},
  {'label': 'Meta & Carousel', 'value': 'Meta&Carousel'},
];
final List<Map<String, String>> statusOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'New', 'value': '0'},
  {'label': 'Followed Up', 'value': '1'},
  {'label': 'Accepted', 'value': '2'},
  {'label': 'Rejected', 'value': '3'},
];

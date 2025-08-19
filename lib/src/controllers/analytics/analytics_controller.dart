import 'package:dio/dio.dart';
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
  RxBool isExportLoading = false.obs;
  Rx<SortOption?> selectedSortOption = Rx<SortOption?>(SortOption.newestDate);

  Rx<DateType?> initialDateType = (DateType.daily).obs;
  Rx<DateType?> selectedDateType = (DateType.daily).obs;

  Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);
  RxMap<String, String> selectedCategory = {'label': 'All', 'value': 'all'}.obs;
  RxList<Map<String, String>> categoryList = <Map<String, String>>[
    {'label': 'All', 'value': 'all'}
  ].obs;
  RxMap<String, String> selectedPic = {'label': 'All', 'value': 'all'}.obs;
  RxList<Map<String, String>> picList = <Map<String, String>>[
    {'label': 'All', 'value': 'all'}
  ].obs;
  RxMap<String, String> selectedClientSource = {'label': 'All', 'value': 'all'}.obs;
  RxList<Map<String, String>> clientSourceList = <Map<String, String>>[
    {'label': 'All', 'value': 'all'}
  ].obs;
  RxMap<String, String> selectedUtm = {'label': 'All', 'value': 'all'}.obs;
  RxList<Map<String, String>> utmList = <Map<String, String>>[
    {'label': 'All', 'value': 'all'}
  ].obs;
  RxMap<String, String> selectedStatus = {'label': 'All', 'value': 'all'}.obs;
  RxList<Map<String, String>> statusList = <Map<String, String>>[
    {'label': 'All', 'value': 'all'},
    {'label': 'New', 'value': '0'},
    {'label': 'Followed Up', 'value': '1'},
    {'label': 'Accepted', 'value': '2'},
    {'label': 'Rejected', 'value': '3'},
  ].obs;

  bool get isFilterApplied =>
      selectedStartDate.value != null ||
      selectedEndDate.value != null ||
      selectedCategory['value'] != 'all' ||
      selectedPic['value'] != 'all' ||
      selectedClientSource['value'] != 'all' ||
      selectedUtm['value'] != 'all' ||
      selectedStatus['value'] != 'all';

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;
  final UserController userController = Get.find<UserController>();

  @override
  void onReady() {
    super.onReady();
    fetchAllFilter();
  }

  void fetchAllFilter() {
    fetchCategoryFilter();
    fetchPicFilter();
    fetchClientSourceFilter();
    fetchUtmFilter();
  }

  Future<void> fetchCategoryFilter() async {
    try {
      final response = await dio.get(
        '$baseUrl/filter/data_services',
        options: Options(
          headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'].map<Map<String, String>>((category) {
          return {
            'value': category['id']?.toString() ?? '',
            'label': category['text']?.toString() ?? '',
          };
        }).toList();

        categoryList.addAll(data);
      }
    } catch (_) {
      categoryList.assignAll(dummyCategoriesOptions);
    }
  }

  Future<void> fetchPicFilter() async {
    try {
      final response = await dio.get(
        '$baseUrl/filter/pic',
        options: Options(
          headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'].map<Map<String, String>>((pic) {
          return {
            'value': pic['value']?.toString() ?? '',
            'label': pic['label']?.toString() ?? '',
          };
        }).toList();

        picList.addAll(data);
      }
    } catch (e) {
      picList.assignAll(dummyPicOptions);
    }
  }

  Future<void> fetchClientSourceFilter() async {
    try {
      final response = await dio.get(
        '$baseUrl/filter/client_source',
        options: Options(
          headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'].map<Map<String, String>>((clientSource) {
          return {
            'value': clientSource['value']?.toString() ?? '',
            'label': clientSource['label']?.toString() ?? '',
          };
        }).toList();

        clientSourceList.assignAll(data);
      }
    } catch (e) {
      clientSourceList.assignAll(dummyClientSourceOptions);
    }
  }

  Future<void> fetchUtmFilter() async {
    try {
      final response = await dio.get(
        '$baseUrl/quotation/fetch/get-all-utm',
        options: Options(
          headers: {'Authorization': 'Bearer ${userController.accesToken.value}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = (response.data as List<dynamic>).map<Map<String, String>>((utm) {
          return {
            'value': utm.toString().replaceAll('&', '%26'),
            'label': utm.toString().replaceAll('&', ' & '),
          };
        }).toList();

        utmList.addAll(data);
      }
    } catch (e) {
      utmList.assignAll(dummyUtmOptions);
    }
  }

  Future<void> fetchData() async {}

  Future<void> exportData() async {}

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
      if (analyticsType == AnalyticsType.quotationTraffic) {
        queryParams.add('utm[]=${selectedUtm['value']}');
      } else {
        queryParams.add('utm=${selectedUtm['value']}');
      }
    }
    if (selectedStatus['value'] != 'all') {
      queryParams.add('status=${selectedStatus['value']}');
    }

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
        return categoryList;
      case AnalyticsFilterType.pic:
        return picList;
      case AnalyticsFilterType.clientSource:
        return clientSourceList;
      case AnalyticsFilterType.utm:
        return utmList;
      case AnalyticsFilterType.status:
        return statusList;
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
    fetchData();
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
    fetchData();
  }

  Future<void> applyFilters() async {
    isFilterLoading(true);
    await fetchData();
    isFilterLoading(false);
  }

  Future<void> resetFilter() async {
    selectedDateType.value = initialDateType.value;
    selectedStartDate.value = null;
    selectedEndDate.value = null;
    selectedCategory.value = {'label': 'All', 'value': 'all'};
    selectedPic.value = {'label': 'All', 'value': 'all'};
    selectedClientSource.value = {'label': 'All', 'value': 'all'};
    selectedUtm.value = {'label': 'All', 'value': 'all'};
    selectedStatus.value = {'label': 'All', 'value': 'all'};

    await applyFilters();
    Get.back();
  }

  void resetSortOption() {
    selectedSortOption.value = SortOption.newestDate;
  }
}

// Dummy Data
final List<Map<String, String>> dummyCategoriesOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'SEO Content Writing', 'value': 'SEO Content Writing'},
  {'label': 'SEO Services', 'value': 'SEO Services'},
  {'label': 'SEM', 'value': 'SEM'},
  {'label': 'Social Media Management', 'value': 'Social Media Management'},
  {'label': 'Digital Marketing', 'value': 'Digital Marketing'},
  {'label': 'Ads', 'value': 'Ads'},
  {'label': 'VISUWISU', 'value': 'VISUWISU'},
  {'label': 'Christmas', 'value': 'Christmas'},
  {'label': 'Embis Reborn', 'value': 'Embis Reborn'},
  {'label': 'Ramadan 2024', 'value': 'Ramadan 2024'},
  {'label': 'New amber', 'value': 'new-amber'},
  {'label': 'Expert Writing', 'value': 'Expert Writing'},
  {'label': 'Press Release', 'value': 'Press Release'},
  {'label': 'Website Copywriting', 'value': 'Website Copywriting'},
  {'label': 'Social Media Copywriting', 'value': 'Social Media Copywriting'},
  {'label': 'Technical Writing', 'value': 'Technical Writing'},
  {'label': 'SEO Article', 'value': 'SEO Article'},
  {'label': 'Evergreen Writing', 'value': 'Evergreen Writing'},
  {'label': 'Evergreen Media Buying', 'value': 'Evergreen Media Buying'},
  {'label': 'Evergreen SEO', 'value': 'Evergreen SEO'},
  {'label': 'Kemerdekaan 2024', 'value': 'Kemerdekaan 2024'},
  {'label': 'SEO', 'value': 'SEO'},
  {'label': 'White Label SEO', 'value': 'White Label SEO'},
  {'label': 'Company Group', 'value': 'Company Group'},
  {'label': 'SEO Training', 'value': 'SEO Training'},
  {
    'label': 'Program Afiliasi | Kemitraan Eksklusif dari cmlabs',
    'value': 'Program Afiliasi | Kemitraan Eksklusif dari cmlabs'
  },
  {'label': 'Agensi Digital', 'value': 'Agensi Digital'},
  {'label': 'Backlink Partnership', 'value': 'Backlink Partnership'},
  {'label': 'Pelatihan SEO', 'value': 'Pelatihan SEO'},
  {'label': 'Program Afiliasi', 'value': 'Program Afiliasi'},
  {'label': 'Digital Agency', 'value': 'Digital Agency'},
  {'label': 'Sapi', 'value': 'sapi'},
  {'label': 'VISUWISU Ignition', 'value': 'VISUWISU Ignition'},
  {'label': 'Franchise Organizations', 'value': 'Franchise Organizations'},
  {'label': 'New service', 'value': 'new-service'},
  {'label': 'Press release', 'value': 'press-release'},
  {'label': 'Media partnership', 'value': 'media-partnership'},
  {'label': 'Media buying', 'value': 'media-buying'},
  {'label': 'Visuwisu', 'value': 'visuwisu'},
  {'label': 'Ramadhan 2024', 'value': 'ramadhan-2024'},
  {'label': 'Expert writing', 'value': 'expert-writing'},
  {'label': 'Christmas', 'value': 'christmas'},
  {'label': 'Seo article', 'value': 'seo-article'},
  {'label': 'Technical writing', 'value': 'technical-writing'},
  {'label': 'Website development', 'value': 'website-development'},
  {'label': 'Social media copywriting', 'value': 'social-media-copywriting'}
];
final List<Map<String, String>> dummyPicOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'Super Admin', 'value': 'Super Admin'},
  {'label': 'Tria Bagus', 'value': 'Tria Bagus'},
  {'label': 'Magang Dev', 'value': 'Magang Dev'},
  {'label': 'Talita Nur', 'value': 'Talita Nur'},
  {'label': 'Rian Febriansyah', 'value': 'Rian Febriansyah'},
  {'label': 'Wahyu Siwananda', 'value': 'Wahyu Siwananda'},
  {'label': 'Backlink Super Admin', 'value': 'Backlink Super Admin'},
  {'label': 'Rifqi Ardhian', 'value': 'Rifqi Ardhian'},
  {'label': 'Imanna Twin', 'value': 'Imanna Twin'},
  {'label': 'Hadi Cahyono', 'value': 'Hadi Cahyono'},
  {'label': 'Agita Ayudya', 'value': 'Agita Ayudya'},
  {'label': 'Lady', 'value': 'Lady'},
  {'label': 'Lady', 'value': 'Lady'},
  {'label': 'Wahyu Siwananda', 'value': 'Wahyu Siwananda'},
  {'label': 'Backlink Vendor', 'value': 'Backlink Vendor'},
  {'label': 'Backlink Transmedia', 'value': 'Backlink Transmedia'},
  {'label': 'Finance', 'value': 'Finance'},
  {'label': 'Lady Y', 'value': 'Lady Y'},
  {'label': 'Wahyu Siwananda', 'value': 'Wahyu Siwananda'},
  {'label': 'Lady', 'value': 'Lady'},
  {'label': 'Vendor Jawa POS', 'value': 'Vendor Jawa POS'},
  {'label': 'Wahyu Siwananda', 'value': 'Wahyu Siwananda'},
  {'label': 'HR', 'value': 'HR'},
  {'label': 'Said Robby', 'value': 'Said Robby'},
  {'label': 'Recruitment', 'value': 'Recruitment'},
  {'label': 'Rochman Maarif', 'value': 'Rochman Maarif'},
  {'label': 'Yuliana Kusumawati', 'value': 'Yuliana Kusumawati'},
  {'label': 'Rizal', 'value': 'Rizal'},
  {'label': 'Staging cmlabsco', 'value': 'Staging cmlabsco'},
  {'label': 'SEO', 'value': 'SEO'},
  {'label': 'Marketing', 'value': 'Marketing'},
  {'label': 'Haziq', 'value': 'Haziq'},
  {'label': 'Testing Fullname', 'value': 'Testing Fullname'},
  {'label': 'akbar', 'value': 'akbar'},
  {'label': 'Intern HR', 'value': 'Intern HR'},
  {'label': 'Hendi Arsanto', 'value': 'Hendi Arsanto'},
  {'label': 'Saffana Fadila', 'value': 'Saffana Fadila'},
  {'label': 'Selsi Selvia', 'value': 'Selsi Selvia'},
  {'label': 'Fernika Windi Ristantika', 'value': 'Fernika Windi Ristantika'},
  {'label': 'Achmad Faris Fadhail', 'value': 'Achmad Faris Fadhail'},
  {'label': 'Alfian Jufri', 'value': 'Alfian Jufri'},
  {'label': 'Alvin Hendrawan', 'value': 'Alvin Hendrawan'},
  {'label': 'Al Mulki', 'value': 'Al Mulki'},
  {'label': 'Khairunnisa Andari', 'value': 'Khairunnisa Andari'},
  {'label': 'Nur Fadilah Kurnia', 'value': 'Nur Fadilah Kurnia'},
  {'label': 'Rifqi Ardhian', 'value': 'Rifqi Ardhian'},
  {'label': 'Mahendra Dwi', 'value': 'Mahendra Dwi'},
  {'label': 'Haekal Ammarsyad', 'value': 'Haekal Ammarsyad'},
  {'label': 'Final Review', 'value': 'Final Review'},
  {'label': 'Gita Kartika', 'value': 'Gita Kartika'},
  {'label': 'pentest', 'value': 'pentest'},
  {'label': 'mobile-rifqi', 'value': 'mobile-rifqi'},
  {'label': 'QA Lady', 'value': 'QA Lady'}
];
final List<Map<String, String>> dummyClientSourceOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'Direct Email', 'value': 'Direct Email'},
  {'label': 'Web WhatsApp', 'value': 'Web WhatsApp'},
  {'label': 'Direct Linkedin', 'value': 'Direct Linkedin'},
  {'label': 'Direct Partnership', 'value': 'Direct Partnership'},
  {'label': 'Direct Visit', 'value': 'Direct Visit'},
  {'label': 'Direct WhatsApp', 'value': 'Direct WhatsApp'},
  {'label': 'Direct Call', 'value': 'Direct Call'},
  {'label': 'Partnership Vendor', 'value': 'Partnership Vendor'},
  {'label': 'Referral', 'value': 'Referral'}
];
final List<Map<String, String>> dummyUtmOptions = [
  {'label': 'All', 'value': 'all'},
  {'label': 'FB & FB', 'value': 'FB%26FB'},
  {'label': 'Gads & Cpc', 'value': 'gads%26cpc'},
  {'label': 'Google & Banner', 'value': 'google%26banner'},
  {'label': 'Meta & Banner', 'value': 'meta%26banner'},
  {'label': 'Google & Cpc', 'value': 'google%26cpc'},
  {'label': 'Meta & Cpc', 'value': 'meta%26cpc'},
  {'label': 'Meta & Carousel', 'value': 'Meta%26carousel'},
  {'label': 'Google & Conversion', 'value': 'google%26Conversion'},
  {'label': 'Google & Banner', 'value': 'Google%26Banner'},
  {'label': 'Google & Carousel', 'value': 'Google%26carousel'},
  {'label': 'Google & Cpc', 'value': 'Google%26cpc'},
  {'label': 'Google & Gdn', 'value': 'Google%26gdn'},
  {'label': 'Googleads & Carousel', 'value': 'Googleads%26carousel'},
  {'label': 'Googleads & Cpc', 'value': 'Googleads%26cpc'},
  {'label': 'Googleads & Gdn', 'value': 'Googleads%26gdn'},
  {'label': 'Meta & CPC', 'value': 'Meta%26CPC'},
  {'label': 'Meta & Gdn', 'value': 'Meta%26gdn'},
  {'label': 'Source & Medium', 'value': 'Source%26Medium'},
];

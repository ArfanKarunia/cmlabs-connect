import 'dart:async';

import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:cmlabs_connect/src/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum NotificationFilterType { timeRange }

class NotificationController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Rx<int> selectedIndex = 0.obs;
  Rx<String?> search = Rx<String?>(null);

  Rx<int> start = 0.obs;
  Rx<int> limit = 10.obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  Rx<Map<String, String>?> selectedTimeRange = Rx<Map<String, String>?>(null);
  String get startDateText => DateFormat('dd MMM yyyy').format(startDate.value ?? DateTime.now());
  String get endDateText => DateFormat('dd MMM yyyy').format(endDate.value ?? DateTime.now());

  RxList<NotificationModel?> todayNotification = <NotificationModel?>[].obs;
  RxList<NotificationModel?> weekNotification = <NotificationModel?>[].obs;
  RxList<NotificationModel?> monthNotification = <NotificationModel?>[].obs;

  Rx<int> unreadAll = 0.obs;
  Rx<int> unreadNew = 0.obs;
  Rx<int> unreadReminder = 0.obs;

  // Configuration
  RxList<Map<String, String>?> quiteDay = <Map<String, String>?>[].obs;
  Rx<bool> pushNotifNewQuotation = false.obs;
  Rx<bool> pushNotifFollowedUpQuotation = false.obs;
  Rx<bool> emailNotifNewQuotation = false.obs;
  Rx<bool> emailNotifFollowedUpQuotation = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchNotification();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchNotification();
    });
  }

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  void setTimeRange(Map<String, String>? range) {
    selectedTimeRange.value = range;
    DateTime now = DateTime.now();

    switch (range?['value']) {
      case "Last 7 days":
        startDate.value = now.subtract(const Duration(days: 7));
        endDate.value = now;
        break;
      case "Last 1 month":
        startDate.value = now.subtract(const Duration(days: 30));
        endDate.value = now;
        break;
      case "Last 3 months":
        startDate.value = now.subtract(const Duration(days: 90));
        endDate.value = now;
        break;
      case "Last 6 months":
        startDate.value = now.subtract(const Duration(days: 180));
        endDate.value = now;
        break;
      case "Last 1 year":
        startDate.value = now.subtract(const Duration(days: 365));
        endDate.value = now;
        break;
      default:
        startDate.value = null;
        endDate.value = null;
        break;
    }
  }

  Future<void> fetchNotification({
    bool isLoadMore = false,
    bool refreshData = false,
  }) async {
    try {
      String? accessToken = userController.accesToken.value;

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 30));

      String startDateString =
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      String endDateString =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      if (isLoadMore) {
        start.value = start.value + limit.value;
      } else {
        start.value = 0;
      }

      if (refreshData) {
        start.value = 0;
        limit.value = todayNotification.length + weekNotification.length + monthNotification.length;
      }

      final response = await dio.get(
        '$baseUrl/notification/list_notification?start=${start.value}&limit=${limit.value}&start_date=$startDateString&end_date=$endDateString',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<NotificationModel> allNotification = rawData.map<NotificationModel>((item) {
            return NotificationModel.fromJson(item);
          }).toList();

          if (!isLoadMore) {
            todayNotification.clear();
            weekNotification.clear();
            monthNotification.clear();
          }

          DateTime now = DateTime.now();

          for (final notification in allNotification) {
            if (notification.createdAt.isAfter(now.subtract(const Duration(days: 1)))) {
              todayNotification.add(notification);
            } else if (notification.createdAt.isAfter(now.subtract(const Duration(days: 7)))) {
              weekNotification.add(notification);
            } else if (notification.createdAt.isAfter(now.subtract(const Duration(days: 30)))) {
              monthNotification.add(notification);
            }
          }

          if (refreshData) {
            limit.value = 10;
          }

          todayNotification.refresh();
          weekNotification.refresh();
          monthNotification.refresh();
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchAmountUnreadNotification() async {
    try {
      String? accessToken = userController.accesToken.value;

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 30));

      String startDateString =
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      String endDateString =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      final response = await dio.get(
        '$baseUrl/notification/list_notification?is_read=0&start=0&limit=50&start_date=$startDateString&end_date=$endDateString',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<NotificationModel> allNotification = rawData.map<NotificationModel>((item) {
            return NotificationModel.fromJson(item);
          }).toList();

          unreadAll.value = 0;
          unreadNew.value = 0;
          unreadReminder.value = 0;

          for (final notification in allNotification) {
            if (notification.isRead == false) {
              unreadAll.value++;
              if (notification.status == 0) {
                unreadNew.value++;
              }

              if (notification.isReminder == true) {
                unreadReminder.value++;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> updateReadParam(int id) async {
    String? accessToken = userController.accesToken.value;

    try {
      final response = await dio.put(
        "$baseUrl/notification/update_notification",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          "id": id,
        },
      );

      debugPrint(response.data);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    if (select.toLowerCase() == 'time_range') {
      result = timeRangeList;
    }

    if (select.toLowerCase() == 'days') {
      result = dayList;
    }

    return result;
  }

  Future<List<NotificationModel?>> fetchHistoryNotification() async {
    List<NotificationModel?> filteredData = [];
    if (startDate.value == null || endDate.value == null) return filteredData;

    try {
      String? accessToken = userController.accesToken.value;

      String startDateString =
          "${startDate.value?.year}-${startDate.value?.month.toString().padLeft(2, '0')}-${startDate.value?.day.toString().padLeft(2, '0')}";
      String endDateString =
          "${endDate.value?.year}-${endDate.value?.month.toString().padLeft(2, '0')}-${endDate.value?.day.toString().padLeft(2, '0')}";

      final response = await dio.get(
        '$baseUrl/notification/list_notification?start_date=$startDateString&end_date=$endDateString',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          filteredData = rawData.map<NotificationModel?>((item) {
            return NotificationModel.fromJson(item);
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }

    return filteredData;
  }

  List<Map<String, String>> getList(NotificationFilterType filter) {
    switch (filter) {
      case NotificationFilterType.timeRange:
        return timeRangeList;
    }
  }

  void setValue({
    required NotificationFilterType filter,
    Map<String, String>? value,
  }) {
    switch (filter) {
      case NotificationFilterType.timeRange:
        setTimeRange(value);
        break;
    }
  }

  void clearQuiteDay() {
    quiteDay.clear();
  }

  final List<Map<String, String>> timeRangeList = [
    {'value': "Last 7 days", 'label': "Last 7 days"},
    {'value': "Last 1 month", 'label': "Last 1 month"},
    {'value': "Last 3 months", 'label': "Last 3 months"},
    {'value': "Last 6 months", 'label': "Last 6 months"},
    {'value': "Last 1 year", 'label': "Last 1 year"},
  ];

  final dayList = [
    {'value': "Monday", 'label': "Monday"},
    {'value': "Tuesday", 'label': "Tuesday"},
    {'value': "Wednesday", 'label': "Wednesday"},
    {'value': "Thursday", 'label': "Thursday"},
    {'value': "Friday", 'label': "Friday"},
    {'value': "Saturday", 'label': "Saturday"},
    {'value': "Sunday", 'label': "Sunday"},
  ];
}

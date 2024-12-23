import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var selectedIndex = 0.obs;
  var search = Rx<String?>(null);

  var start = 0.obs;
  var limit = 10.obs;

  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  var selectTimeRange = Rx<String?>(null);

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  final todayNotification = Rx<List<NotificationModel?>>([]);
  final weekNotification = Rx<List<NotificationModel?>>([]);
  final monthNotification = Rx<List<NotificationModel?>>([]);

  final unreadAll = Rx<int>(0);
  final unreadNew = Rx<int>(0);
  final unreadReminder = Rx<int>(0);

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  void setTimeRange(String? range) {
    selectTimeRange.value = range;
    DateTime now = DateTime.now();

    if (range == "Last 7 days") {
      startDate.value = now.subtract(Duration(days: 7));
      endDate.value = now;
    } else if (range == "Last 1 month") {
      startDate.value = now.subtract(Duration(days: 30));
      endDate.value = now;
    } else if (range == "Last 3 months") {
      startDate.value = now.subtract(Duration(days: 90));
      endDate.value = now;
    } else if (range == "Last 6 months") {
      startDate.value = now.subtract(Duration(days: 180));
      endDate.value = now;
    } else if (range == "Last 1 year") {
      startDate.value = now.subtract(Duration(days: 365));
      endDate.value = now;
    } else {
      startDate.value = null;
      endDate.value = null;
    }
  }

  Future<void> fetchNotification(
      {bool isLoadMore = false, bool refreshData = false}) async {
    print("Fetch Notification");
    try {
      String? accessToken = authenticationController.accesToken.value;

      var endDate = DateTime.now();
      var startDate = endDate.subtract(Duration(days: 30));

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
        limit.value = todayNotification.value.length +
            weekNotification.value.length +
            monthNotification.value.length;
      }

      final response = await dio.get(
        '$baseUrl/notification/list_notification?start=${start.value}&limit=${limit.value}&start_date=$startDateString&end_date=$endDateString',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<NotificationModel> allNotification =
              rawData.map<NotificationModel>((item) {
            return NotificationModel.fromJson(item);
          }).toList();

          if (!isLoadMore) {
            // Clear previous notifications
            todayNotification.value.clear();
            weekNotification.value.clear();
            monthNotification.value.clear();
            
          }

          DateTime now = DateTime.now();

          // Categorize notifications
          for (var notification in allNotification) {
            if (notification.createdAt
                .isAfter(now.subtract(Duration(days: 1)))) {
              // Notification  today
              todayNotification.value.add(notification);
            } else if (notification.createdAt
                .isAfter(now.subtract(Duration(days: 7)))) {
              // Notification last week
              weekNotification.value.add(notification);
            } else if (notification.createdAt
                .isAfter(now.subtract(Duration(days: 30)))) {
              // Notification last month
              monthNotification.value.add(notification);
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
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchAmountUnreadNotification() async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      var endDate = DateTime.now();
      var startDate = endDate.subtract(Duration(days: 30));
      print("StartDate: $startDate");
      print("endDate: $endDate");

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
          List<NotificationModel> allNotification =
              rawData.map<NotificationModel>((item) {
            return NotificationModel.fromJson(item);
          }).toList();

          unreadAll.value = 0;
          unreadNew.value = 0;
          unreadReminder.value = 0;

          // Categorize notifications
          for (var notification in allNotification) {
            if (notification.isRead == false) {
              unreadAll.value++; // Count all unread notifications
              if (notification.status == 0) {
                unreadNew.value++; // Count unread notifications from today
              }

              if (notification.isRemainder == true) {
                unreadReminder.value++; // Count unread reminders
              }
            }
          }

          print("unread all : ${unreadAll.value}");
          print("unread new : ${unreadNew.value}");
          print("unread reminder : ${unreadReminder.value}");

        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> updateReadParam(int id) async {
    String? accessToken = authenticationController.accesToken.value;

    Map<String, dynamic> requestData = {
      "id": id,
    };

    try {
      final response = await dio.put(
        "$baseUrl/notification/update_notification",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: requestData,
      );

      print(response.statusCode);
    } catch (e) {
      print("Error: $e");
    }
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging

    if (select.toLowerCase() == 'time_range') {
      result = timeRangeList;
    }

    return result;
  }

  final timeRangeList = [
    "Last 7 days",
    'Last 1 month',
    'Last 3 months',
    "Last 6 months",
    "Last 1 year",
  ];

  Future<List<NotificationModel?>> fetchHistoryNotification(
      DateTime startDate, DateTime endDate) async {
    List<NotificationModel?> filteredData = [];

    try {
      String? accessToken = authenticationController.accesToken.value;

      // Format tanggal ke dalam string dengan format YYYY-MM-DD
      String startDateString =
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      String endDateString =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      final response = await dio.get(
        '$baseUrl/notification/list_notification?start_date=$startDateString&end_date=$endDateString',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          // Mengonversi data mentah menjadi daftar NotificationModel
          filteredData = rawData.map<NotificationModel?>((item) {
            return NotificationModel.fromJson(item);
          }).toList();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return filteredData; // Mengembalikan daftar notifikasi
  }
}

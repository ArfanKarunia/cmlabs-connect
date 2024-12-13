import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

class NewNotificationView extends StatefulWidget {
  NewNotificationView({super.key});

  @override
  State<NewNotificationView> createState() => _NewNotificationViewState();
}

class _NewNotificationViewState extends State<NewNotificationView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final NotificationController notificationController =
      Get.put(NotificationController());

  late ScrollController scrollController;

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    notificationController.fetchNotification();

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    notificationController.fetchNotification();

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    bool isLoadMoreInProgress = false;

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isLoadMoreInProgress) return;

        isLoadMoreInProgress = true;

        await Future.delayed(Duration(milliseconds: 500));

        await notificationController.fetchNotification(
            isLoadMore: isLoadMoreInProgress);

        isLoadMoreInProgress = false;
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SmartRefresher(
          enablePullDown: true,
          header: ClassicHeader(
            refreshStyle: RefreshStyle.Follow,
            refreshingIcon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.text_4,
                strokeWidth: 2,
              ),
            ),
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          child: ListView(
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Obx(
                () {
                  var todayNew = notificationController.todayNotification.value
                      .where((notif) => notif?.status == 0)
                      .toList();

                  return todayNew.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_1,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: todayNew.length,
                              itemBuilder: (context, index) {
                                var notifToday = todayNew[index]!;
                                return NotificationTile(
                                  id: notifToday.id,
                                  name: notifToday.company,
                                  date: notifToday.createdAt,
                                  isRead: notifToday.isRead,
                                  isReminder: notifToday.isRemainder,
                                );
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  var weekNew = notificationController.weekNotification.value
                      .where((notif) => notif?.status == 0)
                      .toList();

                  return weekNew.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "This Week",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_1,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: weekNew.length,
                              itemBuilder: (context, index) {
                                var notifWeek = weekNew[index]!;
                                return NotificationTile(
                                  id: notifWeek.id,
                                  name: notifWeek.company,
                                  date: notifWeek.createdAt,
                                  isRead: notifWeek.isRead,
                                  isReminder: notifWeek.isRemainder,
                                );
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),
              Obx(
                () {
                  var monthNew = notificationController.monthNotification.value
                      .where((notif) => notif?.status == 0)
                      .toList();

                  return monthNew.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "This Month",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_1,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: monthNew.length,
                              itemBuilder: (context, index) {
                                var notifMonth = monthNew[index]!;
                                return NotificationTile(
                                  id: notifMonth.id,
                                  name: notifMonth.company,
                                  date: notifMonth.createdAt,
                                  isRead: notifMonth.isRead,
                                  isReminder: notifMonth.isRemainder,
                                );
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "No more data",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.text_4,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

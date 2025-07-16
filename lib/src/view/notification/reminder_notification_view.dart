import 'package:cmlabs_connect/src/controllers/notification/notification_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../constant/fontstyle.dart';
import '../../widgets/default_header.dart';
import '../../widgets/notification_tile.dart';

class ReminderNotificationView extends StatefulWidget {
  const ReminderNotificationView({super.key});

  @override
  State<ReminderNotificationView> createState() => _ReminderNotificationViewState();
}

class _ReminderNotificationViewState extends State<ReminderNotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late ScrollController scrollController;

  void _onRefresh() async {
    await Future.delayed(Durations.extralong4);
    controller.fetchNotification();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Durations.extralong4);
    controller.fetchNotification();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    bool isLoadMoreInProgress = false;
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLoadMoreInProgress) return;
        isLoadMoreInProgress = true;
        await Future.delayed(Durations.long2);
        await controller.fetchNotification(isLoadMore: isLoadMoreInProgress);
        isLoadMoreInProgress = false;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      body: SmartRefresher(
        enablePullDown: true,
        header: const DefaultSmartRefresherHeader(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Text(
              "Today",
              style: bold.copyWith(color: AppColors.text_1),
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                final todayReminders =
                    controller.todayNotification.where((notif) => notif?.isReminder == true).toList();
                return todayReminders.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todayReminders.length,
                        itemBuilder: (context, index) {
                          final notifToday = todayReminders[index];
                          return NotificationTile(
                            id: notifToday?.id ?? 0,
                            name: notifToday?.company ?? "",
                            date: notifToday?.createdAt ?? DateTime.now(),
                            isRead: notifToday?.isRead ?? false,
                            isReminder: notifToday?.isReminder ?? false,
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "No more data",
                          style: regular.copyWith(color: AppColors.text_4),
                          textAlign: TextAlign.center,
                        ),
                      );
              },
            ),
            const SizedBox(height: 20),
            Text(
              "This Week",
              style: bold.copyWith(color: AppColors.text_1),
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                final weekReminders = controller.weekNotification.where((notif) => notif?.isReminder == true).toList();

                return weekReminders.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: weekReminders.length,
                        itemBuilder: (context, index) {
                          final notifWeek = weekReminders[index];
                          return NotificationTile(
                            id: notifWeek?.id ?? 0,
                            name: notifWeek?.company ?? "",
                            date: notifWeek?.createdAt ?? DateTime.now(),
                            isRead: notifWeek?.isRead ?? false,
                            isReminder: notifWeek?.isReminder ?? false,
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "No more data",
                          style: regular.copyWith(color: AppColors.text_4),
                          textAlign: TextAlign.center,
                        ),
                      );
              },
            ),
            const SizedBox(height: 20),
            Text(
              "This Month",
              style: bold.copyWith(color: AppColors.text_1),
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                final monthReminders =
                    controller.monthNotification.where((notif) => notif?.isReminder == true).toList();

                return monthReminders.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: monthReminders.length,
                        itemBuilder: (context, index) {
                          final notifMonth = monthReminders[index];
                          return NotificationTile(
                            id: notifMonth?.id ?? 0,
                            name: notifMonth?.company ?? "",
                            date: notifMonth?.createdAt ?? DateTime.now(),
                            isRead: notifMonth?.isRead ?? false,
                            isReminder: notifMonth?.isReminder ?? false,
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "No more data",
                          style: regular.copyWith(color: AppColors.text_4),
                          textAlign: TextAlign.center,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

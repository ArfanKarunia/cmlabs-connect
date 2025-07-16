import 'package:cmlabs_connect/src/controllers/notification/notification_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../constant/fontstyle.dart';
import '../../widgets/default_header.dart';

class NewNotificationView extends StatefulWidget {
  const NewNotificationView({super.key});

  @override
  State<NewNotificationView> createState() => _NewNotificationViewState();
}

class _NewNotificationViewState extends State<NewNotificationView> {
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
                final todayNew = controller.todayNotification.where((notif) => notif?.status == 0).toList();

                return todayNew.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todayNew.length,
                        itemBuilder: (context, index) {
                          final notifToday = todayNew[index];
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
                final weekNew = controller.weekNotification.where((notif) => notif?.status == 0).toList();

                return weekNew.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: weekNew.length,
                        itemBuilder: (context, index) {
                          final notifWeek = weekNew[index];
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
                final monthNew = controller.monthNotification.where((notif) => notif?.status == 0).toList();

                return monthNew.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: monthNew.length,
                        itemBuilder: (context, index) {
                          final notifMonth = monthNew[index];
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

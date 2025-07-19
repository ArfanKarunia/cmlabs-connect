// import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/notification/notification_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/view/notification/all_notification_view.dart';
import 'package:cmlabs_connect/src/view/notification/history_notification_view.dart';
import 'package:cmlabs_connect/src/view/notification/new_notification_view.dart';
import 'package:cmlabs_connect/src/view/notification/reminder_notification_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../widgets/default_appbar.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor2,
        appBar: defaultAppBar(
          'Notification',
          titleSpacing: 0,
          bottom: TabBar(
            labelStyle: bold.copyWith(color: AppColors.primary),
            unselectedLabelStyle: bold.copyWith(color: AppColors.text_4),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            labelPadding: EdgeInsets.zero,
            dividerHeight: 0,
            tabs: [
              NotificationTabBar(title: 'All', unread: controller.unreadAll),
              NotificationTabBar(title: 'New', unread: controller.unreadNew),
              NotificationTabBar(title: 'Reminder', unread: controller.unreadReminder),
              const NotificationTabBar(title: 'History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllNotificationView(),
            NewNotificationView(),
            ReminderNotificationView(),
            HistoryNotificationView(),
          ],
        ),
      ),
    );
  }
}

class NotificationTabBar extends StatelessWidget {
  final String title;
  final Rx<int>? unread;
  const NotificationTabBar({super.key, required this.title, this.unread});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Tab(text: title)),
        if (unread != null) ...[
          Obx(
            () => unread?.value != 0
                ? Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.danger,
                      child: Text(
                        "${unread?.value}",
                        style: regular.copyWith(color: AppColors.white_1, fontSize: 10),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }
}

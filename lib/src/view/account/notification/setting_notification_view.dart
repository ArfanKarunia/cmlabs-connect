import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../controllers/notification/notification_controller.dart';
import '../../../constant/fontstyle.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';
import '../../../widgets/tag_button.dart';

class SettingNotificationView extends StatefulWidget {
  const SettingNotificationView({super.key});

  @override
  State<SettingNotificationView> createState() => _SettingNotificationViewState();
}

class _SettingNotificationViewState extends State<SettingNotificationView> {
  final NotificationController notificationController = Get.find<NotificationController>();

  bool pushNotifNewQuotation = false;
  bool pushNotifFollowedUpQuotation = false;
  bool emailNotifNewQuotation = false;
  bool emailNotifFollowedUpQuotation = false;

  TimeOfDay? fromTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Notification Setting', titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Push Notification",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('New Quotation Inbox', style: regular),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: pushNotifNewQuotation,
                    onChanged: (value) => setState(() => pushNotifNewQuotation = value),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFD8DAE5),
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                    inactiveThumbColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Follow Up Reminder', style: regular),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: pushNotifFollowedUpQuotation,
                    onChanged: (value) => setState(() => pushNotifFollowedUpQuotation = value),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFD8DAE5),
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                    inactiveThumbColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quite Mode
          Text(
            "Quite Mode",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),
          const SizedBox(height: 7),
          Text(
            "Mute the notification at night or whenever you need to focus.",
            style: regular.copyWith(fontSize: 12, color: AppColors.text_1),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Days",
                style: bold.copyWith(fontSize: 14, color: AppColors.text_1),
              ),
              Obx(
                () => notificationController.quiteDay.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          notificationController.clearQuiteDay();
                          notificationController.quiteDay.refresh();
                        },
                        child: Text(
                          "Clear",
                          style: regular.copyWith(
                            fontSize: 10,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomSelectField(
            onTap: () {
              Get.toNamed(
                AppRoutes.notificationSelect,
                arguments: {
                  'title': "Days",
                  'filter': NotificationFilterType.days,
                  'isMultipleChoice': true,
                },
              );
            },
            child: Obx(
              () {
                return notificationController.quiteDay.isEmpty
                    ? const InboxTextOnField(title: 'Choose Days', selected: null)
                    : Wrap(
                        clipBehavior: Clip.antiAlias,
                        children: List.generate(
                          notificationController.quiteDay.length,
                          (index) {
                            Map<String, String>? day = notificationController.quiteDay[index];

                            return FittedBox(
                              child: TagButton(
                                statusLabel: day?['label'] ?? '',
                                onPressed: () => notificationController.quiteDay.removeAt(index),
                              ),
                            );
                          },
                        ),
                      );
                //   return InboxTextOnField(
                //   title: 'Choose Days',
                //   selected: notificationController.quiteDay.isNotEmpty ? notificationController.quiteDay.first : null,
                // );
              },
            ),
          ),

          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InboxAddField(
                  title: 'Start Time',
                  child: CustomSelectField(
                    icon: Ionicons.time_outline,
                    child: InboxTextOnField(
                      title: 'Select Time',
                      selected: fromTime != null
                          ? {
                              'label': fromTime?.format(context) ?? '',
                              'value': fromTime?.format(context) ?? '',
                            }
                          : null,
                    ),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child ?? const SizedBox.shrink(),
                          );
                        },
                      );

                      if (pickedTime != null) setState(() => fromTime = pickedTime);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InboxAddField(
                  title: 'End Time',
                  child: CustomSelectField(
                    icon: Ionicons.time_outline,
                    child: InboxTextOnField(
                      title: 'Select Time',
                      selected: endTime != null
                          ? {
                              'label': endTime?.format(context) ?? '',
                              'value': endTime?.format(context) ?? '',
                            }
                          : null,
                    ),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child ?? const SizedBox.shrink(),
                          );
                        },
                      );

                      if (pickedTime != null) setState(() => endTime = pickedTime);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email Notification
          Text(
            "Email Notification",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('New Quotation Inbox', style: regular),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: emailNotifNewQuotation,
                    onChanged: (value) => setState(() => emailNotifNewQuotation = value),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFD8DAE5),
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                    inactiveThumbColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Text('Follow Up Reminder', style: regular),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: emailNotifFollowedUpQuotation,
                    onChanged: (value) => setState(() => emailNotifFollowedUpQuotation = value),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFD8DAE5),
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                    inactiveThumbColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../controllers/notification/notification_controller.dart';
import '../../../constant/fontstyle.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';
import '../../../widgets/tag_button.dart';

class SettingNotificationView extends StatefulWidget {
  const SettingNotificationView({super.key});

  @override
  State<SettingNotificationView> createState() => _SettingNotificationViewState();
}

class _SettingNotificationViewState extends State<SettingNotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Notification Setting', titleSpacing: 0),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
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
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.pushNotifNewQuotation.value,
                            onChanged: (value) => controller.pushNotifNewQuotation.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text('New Case Studies Inbox', style: regular),
                    const SizedBox(width: 10),
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.pushNotifNewCaseStudies.value,
                            onChanged: (value) => controller.pushNotifNewCaseStudies.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text('New Contact Us Inbox', style: regular),
                    const SizedBox(width: 10),
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.pushNotifNewContactUs.value,
                            onChanged: (value) => controller.pushNotifNewContactUs.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text('New FAQ Inbox', style: regular),
                    const SizedBox(width: 10),
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.pushNotifNewFAQ.value,
                            onChanged: (value) => controller.pushNotifNewFAQ.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
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
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.pushNotifFollowedUpReminder.value,
                            onChanged: (value) => controller.pushNotifFollowedUpReminder.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
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
                    GestureDetector(
                      onTap: () => controller.clearQuiteMode(),
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
                      return controller.quiteModeDays.isEmpty
                          ? const InboxTextOnField(title: 'Choose Days', selected: null)
                          : Wrap(
                              clipBehavior: Clip.antiAlias,
                              children: List.generate(
                                controller.quiteModeDays.length,
                                (index) {
                                  Map<String, String>? day = controller.quiteModeDays[index];

                                  return FittedBox(
                                    child: TagButton(
                                      statusLabel: day?['label'] ?? '',
                                      onPressed: () => controller.quiteModeDays.removeAt(index),
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
                Obx(
                  () {
                    TimeOfDay? fromTime = controller.quietModeStartTime.value;
                    TimeOfDay? endTime = controller.quietModeEndTime.value;

                    return Row(
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
                                        'label': fromTime.format(context),
                                        'value': fromTime.format(context),
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

                                if (pickedTime != null) controller.quietModeStartTime.value = pickedTime;
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
                                        'label': endTime.format(context),
                                        'value': endTime.format(context),
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

                                if (pickedTime != null) controller.quietModeEndTime.value = pickedTime;
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.emailNotifNewQuotation.value,
                            onChanged: (value) => controller.emailNotifNewQuotation.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Text('New Case Studies Inbox', style: regular),
                    const SizedBox(width: 10),
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.emailNotifNewCaseStudies.value,
                            onChanged: (value) => controller.emailNotifNewCaseStudies.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Text('New Contact Us Inbox', style: regular),
                    const SizedBox(width: 10),
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.emailNotifNewContactUs.value,
                            onChanged: (value) => controller.emailNotifNewContactUs.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Text('New FAQ Inbox', style: regular),
                    const SizedBox(width: 10),
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.emailNotifNewFAQ.value,
                            onChanged: (value) => controller.emailNotifNewFAQ.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
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
                    Obx(
                      () => SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.emailNotifFollowedUpReminder.value,
                            onChanged: (value) => controller.emailNotifFollowedUpReminder.value = value,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: const Color(0xFFD8DAE5),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            inactiveThumbColor: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 200),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.white_1,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      offset: Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 140,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.text_4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => controller.isNotificationSettingLoading.value
                          ? const CustomLoadingButton()
                          : CustomSubmitButton(
                              title: 'Save',
                              onTap: () => controller.updateNotificationSetting(),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Click to save all changes",
                      style: regular.copyWith(fontSize: 10, color: AppColors.text_2),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

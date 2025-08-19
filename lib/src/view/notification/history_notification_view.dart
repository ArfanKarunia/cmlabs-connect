import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cmlabs_connect/src/controllers/notification/notification_controller.dart';
import 'package:cmlabs_connect/src/models/notification_model.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../widgets/custom_select_field.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inbox/inbox_add_field.dart';

class HistoryNotificationView extends StatefulWidget {
  const HistoryNotificationView({super.key});

  @override
  State<HistoryNotificationView> createState() => _HistoryNotificationViewState();
}

class _HistoryNotificationViewState extends State<HistoryNotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  Rx<List<NotificationModel?>> filteredNotification = Rx<List<NotificationModel?>>([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Time Range
          InboxAddField(
            title: 'Select Time Range',
            child: CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.notificationSelect,
                arguments: {
                  'title': 'Time Range',
                  'filter': NotificationFilterType.timeRange,
                  'isMultipleChoice': false,
                },
              ),
              child: Obx(
                () => InboxTextOnField(
                  title: 'Select Time Range',
                  selected: controller.selectedTimeRange.value,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Date Range
          const Text('Date range', style: bold),
          const SizedBox(height: 15),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CustomSelectField(
                      icon: Ionicons.calendar_outline,
                      onTap: () => _selectDateRange(context),
                      child: InboxTextOnField(
                        title: 'Start Date',
                        selected: controller.startDate.value != null
                            ? {'value': controller.startDateText, 'label': controller.startDateText}
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spasi antar form
                Text(
                  "to",
                  style: regular.copyWith(fontSize: 12),
                ),
                const SizedBox(width: 10), // Spasi antar form
                Expanded(
                  child: Obx(
                    () => CustomSelectField(
                      icon: Ionicons.calendar_outline,
                      onTap: () => _selectDateRange(context),
                      child: InboxTextOnField(
                        title: 'End Date',
                        selected: controller.endDate.value != null
                            ? {'value': controller.endDateText, 'label': controller.endDateText}
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          CustomSubmitButton(
            title: 'Search',
            onTap: () => loadFilteredNotifications(),
          ),

          const Divider(height: 40),

          Text(
            "Result History",
            style: bold.copyWith(color: AppColors.text_1),
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              return filteredNotification.value.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.startDateText} s/d ${controller.endDateText}",
                          style: bold.copyWith(fontSize: 12, color: AppColors.text_2),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredNotification.value.length,
                          itemBuilder: (context, index) {
                            final notif = filteredNotification.value[index]!;
                            return NotificationTile(
                              id: notif.id,
                              name: notif.company,
                              date: notif.createdAt,
                              isRead: notif.isRead,
                              isReminder: notif.isReminder,
                            );
                          },
                        ),
                      ],
                    )
                  : const EmptyState();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> loadFilteredNotifications() async {
    try {
      final notifications = await controller.fetchHistoryNotification();
      filteredNotification.value = notifications;
    } catch (_) {}
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      calendarType: CalendarDatePicker2Type.range,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: regular.copyWith(color: AppColors.text_1),
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      selectedDayHighlightColor: const Color(0xFFBCDFFC),
      selectedRangeHighlightColor: const Color(0xFFBCDFFC),
      selectedRangeDayTextStyle: regular.copyWith(color: AppColors.primary),
      selectedDayTextStyle: regular.copyWith(color: AppColors.primary),
      dayTextStyle: regular.copyWith(color: AppColors.lightPrimaryColor),
      daySplashColor: const Color(0xFFBCDFFC),
      dayBorderRadius: BorderRadius.circular(5),
      controlsTextStyle: bold.copyWith(fontSize: 15, color: AppColors.text_1),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      cancelButtonTextStyle: regular.copyWith(color: AppColors.danger),
      okButtonTextStyle: regular.copyWith(color: AppColors.primary),
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true ? AppColors.primary : const Color(0xFFBCDFFC),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    List<DateTime?> defaultDate =
        (controller.selectedTimeRange.value != null) ? [controller.startDate.value, controller.endDate.value] : [];

    final pickedRange = await showCalendarDatePicker2Dialog(
      context: context,
      value: defaultDate,
      config: config,
      dialogBackgroundColor: AppColors.white_1,
      dialogSize: const Size(325, 370),
    );

    if (pickedRange != null) {
      controller.selectedTimeRange.value = null;
      controller.startDate.value = pickedRange.first;
      controller.endDate.value = pickedRange.last;
    }
  }
}

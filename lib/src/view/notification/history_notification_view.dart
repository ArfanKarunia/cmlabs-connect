import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/models/notification_model.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../historical_lead_view.dart';

class HistoryNotificationView extends StatelessWidget {
  HistoryNotificationView({super.key});

  final NotificationController notificationController = Get.put(NotificationController());

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  List<DateTime?>? pickedRange = [];

  var filteredNotification = Rx<List<NotificationModel?>>([]);

  @override
  Widget build(BuildContext context) {
    notificationController.selectTimeRange.value = null;
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () {
                  return SelectField(
                    name: "Select Time Range",
                    child: Container(
                      child: notificationController.selectTimeRange.value == null
                          ? Text(
                              "Select year",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_3,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Text(
                              notificationController.selectTimeRange.value!,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                    onPressed: () {
                      // Get.toNamed(
                      //   AppRoutes.filterSelect,
                      //   arguments: {
                      //     'selectData': "time_range",
                      //     'controller': notificationController,
                      //     'canSearch': false,
                      //     'isMultipleChoice': false,
                      //   },
                      // )?.then(
                      //   (value) {
                      //     notificationController.setTimeRange(value);

                      //     print(notificationController.startDate.value);
                      //     print(notificationController.endDate.value);

                      //     fromDateController.text =
                      //         "${notificationController.startDate.value!.year}-${notificationController.startDate.value!.month}-${notificationController.startDate.value!.day}";
                      //     toDateController.text =
                      //         "${notificationController.endDate.value!.year}-${notificationController.endDate.value!.month}-${notificationController.endDate.value!.day}";
                      //   },
                      // );
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: fromDateController,
                          readOnly: true,
                          cursorColor: AppColors.primary,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_1,
                          ),
                          decoration: InputDecoration(
                            hintText: "Select date",
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.text_4,
                            ),
                            suffixIcon: Icon(Ionicons.calendar_outline),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.text_1,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.danger,
                              fontSize: 11,
                            ),
                          ),
                          onTap: () => _selectDateRange(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Date",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: toDateController,
                          readOnly: true,
                          cursorColor: AppColors.primary,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_1,
                          ),
                          decoration: InputDecoration(
                            hintText: "Select date",
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.text_4,
                            ),
                            suffixIcon: Icon(Ionicons.calendar_outline),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.text_1,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.danger,
                              fontSize: 11,
                            ),
                            filled: true,
                            fillColor: AppColors.white_1,
                          ),
                          onTap: () => _selectDateRange(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    loadFilteredNotifications();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: WidgetStatePropertyAll(Colors.white30),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    "Search",
                    style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Result History",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_1,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () {
                  return filteredNotification.value.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${fromDateController.text} s/d ${toDateController.text}",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_2,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: filteredNotification.value.length,
                              itemBuilder: (context, index) {
                                var notif = filteredNotification.value[index]!;
                                return NotificationTile(
                                  id: notif.id,
                                  name: notif.company,
                                  date: notif.createdAt,
                                  isRead: notif.isRead,
                                  isReminder: notif.isRemainder,
                                );
                              },
                            ),
                          ],
                        )
                      : Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: double.infinity,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Ionicons.briefcase_outline,
                                        color: AppColors.text_4,
                                        size: 40,
                                      ),
                                      Text(
                                        'No available data',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.text_4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                },
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

  Future<void> loadFilteredNotifications() async {
    try {
      // Memanggil fetchHistoryNotification dengan await
      var notifications = await notificationController.fetchHistoryNotification(
        notificationController.startDate.value!,
        notificationController.endDate.value!,
      );

      // Memperbarui filteredNotification dengan hasil yang didapat
      filteredNotification.value = notifications;
    } catch (e) {
      print('Error loading filtered notifications: $e');
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    var config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      calendarType: CalendarDatePicker2Type.range,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.text_1,
      ),
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      selectedDayHighlightColor: Color.fromRGBO(188, 223, 252, 1),
      selectedRangeHighlightColor: Color.fromRGBO(188, 223, 252, 1),
      selectedDayTextStyle: GoogleFonts.plusJakartaSans(color: AppColors.primary),
      dayTextStyle: GoogleFonts.plusJakartaSans(color: Color.fromRGBO(143, 202, 250, 1)),
      selectedRangeDayTextStyle: GoogleFonts.plusJakartaSans(color: AppColors.primary),
      controlsTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.text_1,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayBorderRadius: BorderRadius.circular(5),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      cancelButtonTextStyle: GoogleFonts.plusJakartaSans(color: AppColors.danger),
      okButtonTextStyle: GoogleFonts.plusJakartaSans(color: AppColors.primary),
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
                        color: isSelected == true ? AppColors.primary : Color.fromRGBO(143, 202, 250, 1),
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

    List<DateTime?> defaultDate = (notificationController.selectTimeRange.value != null)
        ? [notificationController.startDate.value, notificationController.endDate.value]
        : [];

    pickedRange = await showCalendarDatePicker2Dialog(
      context: context,
      value: defaultDate,
      config: config,
      dialogBackgroundColor: AppColors.white_1,
      dialogSize: const Size(325, 370),
    );

    if (pickedRange!.isNotEmpty) {
      notificationController.startDate.value = pickedRange!.first;
      notificationController.endDate.value = pickedRange!.last;
    }

    if (pickedRange != null) {
      if (pickedRange!.first != null) {
        fromDateController.text = "${pickedRange!.first!.year}-${pickedRange!.first!.month}-${pickedRange!.first!.day}";
      }
      if (pickedRange!.last != null) {
        toDateController.text = "${pickedRange!.last!.year}-${pickedRange!.last!.month}-${pickedRange!.last!.day}";
      }
    }
  }
}

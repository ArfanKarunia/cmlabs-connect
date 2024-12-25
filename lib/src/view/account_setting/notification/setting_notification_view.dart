import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class SettingNotificationView extends StatelessWidget {
  SettingNotificationView({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  final pushNotifNewQuotation = Rx<bool>(false);
  final pushNotifFollowedUpQuotation = Rx<bool>(false);

  final emailNotifNewQuotation = Rx<bool>(false);
  final emailNotifFollowedUpQuotation = Rx<bool>(false);

  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final formattedTime =
          pickedTime.format(context); // Format sesuai kebutuhan
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Notification Setting",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Push Notification",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.text_1,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text(
                  "New Quotation Inbox",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.text_1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () {
                    return SizedBox(
                      height: 35,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          thumbColor: WidgetStatePropertyAll(AppColors.white_1),
                          trackOutlineWidth: WidgetStatePropertyAll(0),
                          trackOutlineColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          trackColor: (!pushNotifNewQuotation.value)
                              ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                              : WidgetStatePropertyAll(AppColors.primary),
                          value: pushNotifNewQuotation.value,
                          onChanged: (bool value) {
                            pushNotifNewQuotation.value =
                                !pushNotifNewQuotation.value;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Follow Up Reminder",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.text_1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () {
                    return SizedBox(
                      height: 35,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          thumbColor: WidgetStatePropertyAll(AppColors.white_1),
                          trackOutlineWidth: WidgetStatePropertyAll(0),
                          trackOutlineColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          trackColor: (!pushNotifFollowedUpQuotation.value)
                              ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                              : WidgetStatePropertyAll(AppColors.primary),
                          value: pushNotifFollowedUpQuotation.value,
                          onChanged: (bool value) {
                            pushNotifFollowedUpQuotation.value =
                                !pushNotifFollowedUpQuotation.value;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Quite Mode",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.text_1,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              "Mute the notification at night or whenever you need to focus.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.text_1,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose Days",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text_1,
                  ),
                ),
                Obx(
                  () {
                    return notificationController.quiteDay.value.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Get.defaultDialog(
                                title: "Confirmation",
                                middleText:
                                    "Are you sure you want to clear the selected days?",
                                textConfirm: "Yes",
                                textCancel: "No",
                                confirmTextColor: Colors.white,
                                backgroundColor: AppColors.white_1,
                                titlePadding: EdgeInsets.only(top: 20),
                                titleStyle: GoogleFonts.plusJakartaSans(color: AppColors.text_1, fontSize: 20, fontWeight: FontWeight.bold,),
                                
                                middleTextStyle: GoogleFonts.plusJakartaSans(color: AppColors.text_1, fontSize: 12,),
                                radius: 10,
                                contentPadding: EdgeInsets.all(20),
                                buttonColor: AppColors.primary,
                                onConfirm: () {
                                  notificationController.clearQuiteDay();
                                  notificationController.quiteDay.refresh();
                                  Get.back(); // Tutup dialog setelah konfirmasi
                                },
                                onCancel: () {
                                  Get.back(); // Tutup dialog jika dibatalkan
                                },
                              );
                            },
                            child: Text(
                              "Clear",
                              style: GoogleFonts.plusJakartaSans(
                                decoration: TextDecoration.underline,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 51,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Obx(
                    () {
                      // var day = notificationController.quiteDay.value;
                      if (notificationController.quiteDay.value.isEmpty) {
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Choose Days",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.text_3,
                            ),
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                notificationController.quiteDay.value
                                    .map((e) => e!['label'] ?? '')
                                    .join(', '),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.text_1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                          )
                        ],
                      );
                    },
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed(
                          "/filterSelect",
                          arguments: {
                            'selectData': "days",
                            'controller': notificationController,
                            'canSearch': false,
                            'isMultipleChoice': true,
                          },
                        )?.then(
                          (value) {
                            notificationController.quiteDay.value.clear();
                            for (var data in value) {
                              notificationController.quiteDay.value.add(data);
                            }
                            notificationController.quiteDay.refresh();
                          },
                        );
                      },
                      child: Icon(
                        Ionicons.chevron_down_outline,
                        color: AppColors.text_1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Time",
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
                        controller: fromTimeController,
                        readOnly: true,
                        cursorColor: AppColors.primary,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_1,
                        ),
                        decoration: InputDecoration(
                          hintText: "Select Time",
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_4,
                          ),
                          suffixIcon: Icon(Ionicons.time_outline),
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
                        onTap: () => _selectTime(context, fromTimeController),
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
                        "End Time",
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
                        controller: endTimeController,
                        readOnly: true,
                        cursorColor: AppColors.primary,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_1,
                        ),
                        decoration: InputDecoration(
                          hintText: "Select Time",
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_4,
                          ),
                          suffixIcon: Icon(Ionicons.time_outline),
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
                        onTap: () => _selectTime(context, endTimeController),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Email Notification",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.text_1,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text(
                  "New Quotation Inbox",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.text_1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () {
                    return SizedBox(
                      height: 35,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          thumbColor: WidgetStatePropertyAll(AppColors.white_1),
                          trackOutlineWidth: WidgetStatePropertyAll(0),
                          trackOutlineColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          trackColor: (!emailNotifNewQuotation.value)
                              ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                              : WidgetStatePropertyAll(AppColors.primary),
                          value: emailNotifNewQuotation.value,
                          onChanged: (bool value) {
                            emailNotifNewQuotation.value =
                                !emailNotifNewQuotation.value;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Follow Up Reminder",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.text_1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () {
                    return SizedBox(
                      height: 35,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          thumbColor: WidgetStatePropertyAll(AppColors.white_1),
                          trackOutlineWidth: WidgetStatePropertyAll(0),
                          trackOutlineColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          trackColor: (!emailNotifFollowedUpQuotation.value)
                              ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                              : WidgetStatePropertyAll(AppColors.primary),
                          value: pushNotifFollowedUpQuotation.value,
                          onChanged: (bool value) {
                            emailNotifFollowedUpQuotation.value =
                                !emailNotifFollowedUpQuotation.value;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

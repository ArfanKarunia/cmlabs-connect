import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../historical_lead_view.dart';

class HistoryNotificationView extends StatelessWidget {
  HistoryNotificationView({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectField(
                name: "Select Time Range",
                child: Container(
                  child: Text(
                    "Select year",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(
                    "/filterSelect",
                    arguments: {
                      'selectData': "year",
                      'controller': notificationController,
                      'canSearch': false,
                    },
                  )?.then(
                    (value) {},
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectField(
                          name: "Start Date",
                          child: Container(
                            child: Text(
                              "Select Start Date",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(
                              "/filterSelect",
                              arguments: {
                                'selectData': "year",
                                'controller': notificationController,
                                'canSearch': false,
                              },
                            )?.then(
                              (value) {
                                // historicalLeadController.year1.value = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectField(
                          name: "End Date",
                          child: Container(
                              child: Text(
                            "Select month",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_3,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          onPressed: () {
                            Get.toNamed(
                              "/filterSelect",
                              arguments: {
                                'selectData': "month",
                                'controller': notificationController,
                                'canSearch': false,
                              },
                            )?.then(
                              (value) {},
                            );
                          },
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
                  onPressed: () {},
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
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Last 7 days",
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
                itemCount: 4,
                itemBuilder: (context, index) {
                  return NotificationTile(
                    name: 'Nama Perusahaan',
                    date: DateTime.now(),
                    isRead: index % 2 == 0,
                    isReminder: index % 2 != 0,
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
}

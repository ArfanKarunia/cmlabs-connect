import 'package:cmlabs_connect/src/controllers/historical_lead_controller.dart';
import 'package:cmlabs_connect/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';
import '../widgets/custom_buttom.dart';

class HistoricalLeadView extends StatelessWidget {
  HistoricalLeadView({super.key});

  final HistoricalLeadController historicalLeadController =
      Get.put(HistoricalLeadController());

  @override
  Widget build(BuildContext context) {
    historicalLeadController.clear();

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        surfaceTintColor: Color(0xFFF9F9F9),
        backgroundColor: Color(0xFFF9F9F9),
        title: Text(
          "Leads Historical Data New",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Filter Data Range 1",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text_2,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Obx(
                () {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectField(
                              name: "Year",
                              child: Container(
                                  child: (historicalLeadController
                                              .year1.value ==
                                          null)
                                      ? Text(
                                          "Select year",
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.text_3,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : Text(
                                          historicalLeadController
                                                  .year1.value!['label'] ??
                                              '-',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.text_1,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                              onPressed: () {
                                Get.toNamed(
                                  "/filterSelect",
                                  arguments: {
                                    'selectData': "year",
                                    'controller': historicalLeadController,
                                    'canSearch': false,
                                    'isMultipleChoice': false,
                                  },
                                )?.then(
                                  (value) {
                                    historicalLeadController.year1.value =
                                        value;
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
                              name: "Month",
                              child: Container(
                                  child: (historicalLeadController
                                              .month1.value ==
                                          null)
                                      ? Text(
                                          "Select month",
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.text_3,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : Text(
                                          historicalLeadController
                                              .month1.value!['label'] ?? '-',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.text_1,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                              onPressed: () {
                                Get.toNamed(
                                  "/filterSelect",
                                  arguments: {
                                    'selectData': "month",
                                    'controller': historicalLeadController,
                                    'canSearch': false,
                                    'isMultipleChoice': false,
                                  },
                                )?.then(
                                  (value) {
                                    historicalLeadController.month1.value =
                                        value;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(
                height: 20,
              ),

              Text(
                "Select Filter Data Range 2",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text_2,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Obx(
                () {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectField(
                              name: "Year",
                              child: Container(
                                child: (historicalLeadController.year2.value ==
                                        null)
                                    ? Text(
                                        "Select year",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.text_3,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Text(
                                        historicalLeadController.year2.value!['label'] ?? '-',
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
                                    'controller': historicalLeadController,
                                    'canSearch': false,
                                    'isMultipleChoice': false,
                                  },
                                )?.then(
                                  (value) {
                                    historicalLeadController.year2.value =
                                        value;
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
                              name: "Month",
                              child: Container(
                                child: (historicalLeadController.month2.value ==
                                        null)
                                    ? Text(
                                        "Select month",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.text_3,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Text(
                                        historicalLeadController
                                            .month2.value!['label'] ?? '-',
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
                                    'selectData': "month",
                                    'controller': historicalLeadController,
                                    'canSearch': false,
                                    'isMultipleChoice': false,
                                  },
                                )?.then(
                                  (value) {
                                    historicalLeadController.month2.value =
                                        value;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(
                height: 20,
              ),

              // Button Search

              SizedBox(
                width: double.infinity,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    if (historicalLeadController.isDatePairFilled()) {
                      historicalLeadController.submit();
                    } else {
                      showErrorToast(
                        "one of the month and year combinations must be filled in",
                      );
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: WidgetStatePropertyAll(Colors.white24),
                  ),
                  child: Text(
                    "Search",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Result",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Obx(
                      () {
                        return Row(
                          children: [
                            (historicalLeadController.historicalData1.value !=
                                        null &&
                                    historicalLeadController.year1.value !=
                                        null &&
                                    historicalLeadController.month1.value !=
                                        null)
                                ? ResultDataHistoricalWidget(
                                    index: 1,
                                    year: historicalLeadController.year1.value!['label'] ?? '-',
                                    month:
                                        historicalLeadController.month1.value!['label'] ?? '-',
                                  )
                                : Container(),
                            (historicalLeadController.historicalData2.value !=
                                        null &&
                                    historicalLeadController.year2.value !=
                                        null &&
                                    historicalLeadController.month2.value !=
                                        null)
                                ? ResultDataHistoricalWidget(
                                    index: 2,
                                    year: historicalLeadController.year2.value!['label'] ?? '-',
                                    month:
                                        historicalLeadController.month2.value!['label'] ?? '-',
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultDataHistoricalWidget extends StatelessWidget {
  ResultDataHistoricalWidget({
    super.key,
    required this.index,
    required this.year,
    required this.month,
  });

  final int index;
  final String year;
  final String month;

  final HistoricalLeadController historicalLeadController =
      Get.put(HistoricalLeadController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Data Range $index",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_1,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "$month $year",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_3,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: (index == 1)
                  ? EdgeInsets.only(top: 10, left: 5, bottom: 10)
                  : EdgeInsets.only(top: 10, right: 5, bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.white_1,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(15, 0, 0, 0),
                    offset: Offset(4, 4),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Data",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (index == 1)
                        ? historicalLeadController.historicalData1.value!.total
                            .toString()
                        : historicalLeadController.historicalData2.value!.total
                            .toString(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 13,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Isi Form User",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (index == 1)
                        ? historicalLeadController
                            .historicalData1.value!.formUser
                            .toString()
                        : historicalLeadController
                            .historicalData2.value!.formUser
                            .toString(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 13,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Google Ads",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (index == 1)
                        ? historicalLeadController
                            .historicalData1.value!.googleAds
                            .toString()
                        : historicalLeadController
                            .historicalData2.value!.googleAds
                            .toString(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 13,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Meta Ads",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (index == 1)
                        ? historicalLeadController
                            .historicalData1.value!.metaAds
                            .toString()
                        : historicalLeadController
                            .historicalData2.value!.metaAds
                            .toString(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 13,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Isi Mkt Sendiri",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (index == 1)
                        ? historicalLeadController
                            .historicalData1.value!.marketing
                            .toString()
                        : historicalLeadController
                            .historicalData2.value!.marketing
                            .toString(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 13,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectField extends StatelessWidget {
  SelectField({
    super.key,
    required this.name,
    required this.child,
    required this.onPressed,
    this.isMandatory = false,
  });

  String name;
  bool isMandatory;
  VoidCallback onPressed;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_3,
              ),
            ),
            (isMandatory)
                ? Text(
                    "*",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 51,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryText),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                child: child,
                width: double.infinity,
              ),
              Container(
                height: 45,
                width: 45,
                child: CustomButton(
                  backgroundColor: AppColors.white_1,
                  onPressed: onPressed,
                  child: const Icon(
                    Ionicons.chevron_down_outline,
                    color: AppColors.text_1,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

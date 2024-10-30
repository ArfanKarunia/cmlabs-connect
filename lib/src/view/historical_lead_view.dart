import 'package:cmlabs_connect/src/controllers/filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';
import '../widgets/custom_buttom.dart';

class HistoricalLeadView extends StatelessWidget {
  HistoricalLeadView({super.key});

  final FilterController filterController = Get.put(FilterController());

  // Range Date 1
  DateTime? temporaryStartDate1;
  DateTime? temporaryEndDate1;

  final TextEditingController startDateController1 = TextEditingController();
  final TextEditingController endDateController1 = TextEditingController();

  RxString startDateError1 = ''.obs;
  RxString endDateError1 = ''.obs;

  // Range Date 1
  DateTime? temporaryStartDate2;
  DateTime? temporaryEndDate2;

  final TextEditingController startDateController2 = TextEditingController();
  final TextEditingController endDateController2 = TextEditingController();

  RxString startDateError2 = ''.obs;
  RxString endDateError2 = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Filter",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Data range",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        focusColor: AppColors.primary,
                        suffixIcon: Icon(
                          Ionicons.calendar_outline,
                          color: AppColors.text_1,
                        ),
                        hintText: "Select date",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryText, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        // errorText: startDateError.value.isNotEmpty
                        //     ? startDateError.value
                        //     : null,
                      ),
                      readOnly: true,
                      controller: startDateController1,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: filterController.startDate.value ??
                              DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          temporaryStartDate1 = pickedDate;
                          startDateController1.text =
                              DateFormat('dd MMM yyyy').format(pickedDate);
                          // validateDateFields();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar form
                  Text(
                    "to",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar form
                  Expanded(child: Obx(
                    () {
                      return TextFormField(
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          focusColor: AppColors.primary,
                          suffixIcon: Icon(
                            Ionicons.calendar_outline,
                            color: AppColors.text_1,
                          ),
                          hintText: "Select date",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primaryText, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                          errorText: endDateError1.value.isNotEmpty
                              ? endDateError1.value
                              : null,
                        ),
                        readOnly: true,
                        controller: endDateController1,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            temporaryEndDate1 = pickedDate;
                            endDateController1.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                            // validateDateFields();
                          }
                        },
                      );
                    },
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Text(
              "Data range",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        focusColor: AppColors.primary,
                        suffixIcon: Icon(
                          Ionicons.calendar_outline,
                          color: AppColors.text_1,
                        ),
                        hintText: "Select date",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryText, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        // errorText: startDateError.value.isNotEmpty
                        //     ? startDateError.value
                        //     : null,
                      ),
                      readOnly: true,
                      controller: startDateController2,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: filterController.startDate.value ??
                              DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          temporaryStartDate2 = pickedDate;
                          startDateController2.text =
                              DateFormat('dd MMM yyyy').format(pickedDate);
                          // validateDateFields();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar form
                  Text(
                    "to",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar form
                  Expanded(child: Obx(
                    () {
                      return TextFormField(
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          focusColor: AppColors.primary,
                          suffixIcon: Icon(
                            Ionicons.calendar_outline,
                            color: AppColors.text_1,
                          ),
                          hintText: "Select date",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primaryText, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                          errorText: endDateError2.value.isNotEmpty
                              ? endDateError2.value
                              : null,
                        ),
                        readOnly: true,
                        controller: endDateController2,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            temporaryEndDate2 = pickedDate;
                            endDateController2.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                            // validateDateFields();
                          }
                        },
                      );
                    },
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Text(
              "Filter Data",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
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
                  // Obx(
                  //   () {
                  //     if (filterController.filterCategoryList.isEmpty) {
                  //       return Container(
                  //         padding: EdgeInsets.only(left: 10),
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           "All",
                  //           style: GoogleFonts.plusJakartaSans(
                  //             fontSize: 14,
                  //             color: AppColors.text_3,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     return ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: filterController.filterCategoryList.length,
                  //       itemBuilder: (context, index) {
                  //         final category =
                  //             filterController.filterCategoryList[index];
                  //         return TagButton(
                  //           statusLabel: category['label'] ?? '-',
                  //           onPressed: () {
                  //             filterController.deleteFilterCategory(category);
                  //           },
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  Container(
                    height: 45,
                    width: 45,
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed("/filterSelect", arguments: "category");
                      },
                      child: Icon(
                        Ionicons.chevron_down_outline,
                        color: AppColors.text_1,
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 15,
            ),

            // Button Search

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
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
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

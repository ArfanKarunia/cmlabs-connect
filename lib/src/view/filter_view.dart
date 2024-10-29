import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/filter_controller.dart';
import '../controllers/quotation_controller.dart';
import '../utils/color.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/tag_button.dart';

class FilterView extends StatelessWidget {
  FilterView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final FilterController filterController = Get.put(FilterController());

  final Rx<DateTime?> temporaryStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> temporaryEndDate = Rx<DateTime?>(null);

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // filterController.filter.value = '';

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        title: Text(
          "Filter",
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
                      decoration: const InputDecoration(
                        focusColor: AppColors.primary,
                        suffixIcon: Icon(
                          Ionicons.calendar_outline,
                          color: AppColors.text_1,
                        ),
                        hintText: "Select date",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      readOnly: true,
                      controller: startDateController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              quotationController.filterStartDate.value ??
                                  DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          temporaryStartDate.value = pickedDate;
                          startDateController.text =
                              DateFormat('dd MMM yyyy').format(pickedDate);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar form
                  const Text(
                    "to",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 10), // Spasi antar form
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: const InputDecoration(
                        focusColor: AppColors.primary,
                        suffixIcon: Icon(
                          Ionicons.calendar_outline,
                          color: AppColors.text_1,
                        ),
                        hintText: "Select date",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      readOnly: true,
                      controller: endDateController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              quotationController.filterEndDate.value ??
                                  DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          temporaryEndDate.value = pickedDate;
                          endDateController.text =
                              DateFormat('dd MMM yyyy').format(pickedDate);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Category",
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
                  Obx(
                    () {
                      if (filterController.filterCategoryList.isEmpty) {
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.text_3,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filterController.filterCategoryList.length,
                        itemBuilder: (context, index) {
                          final category =
                              filterController.filterCategoryList[index];
                          return TagButton(
                            statusLabel: category['label'] ?? '-',
                            onPressed: () {
                              filterController.deleteFilterCategory(category);
                            },
                          );
                        },
                      );
                    },
                  ),
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
              height: 20,
            ),
            Text(
              "PIC",
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
                  Obx(
                    () {
                      if (filterController.filterPicList.isEmpty) {
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.text_3,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filterController.filterPicList.length,
                        itemBuilder: (context, index) {
                          final pic =
                              filterController.filterPicList[index];
                          return TagButton(
                            statusLabel: pic['label'] ?? '-',
                            onPressed: () {
                              filterController.deleteFilterPic(pic);
                            },
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed("/filterSelect", arguments: "pic");
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
              height: 20,
            ),
            Text(
              "Status",
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
                  Obx(
                    () {
                      if (filterController.filterStatusList.isEmpty) {
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.text_3,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filterController.filterStatusList.length,
                        itemBuilder: (context, index) {
                          final status =
                              filterController.filterStatusList[index];
                          return TagButton(
                            statusLabel: status['label'] ?? '-',
                            onPressed: () {
                              filterController.deleteFilterStatus(status);
                            },
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed("/filterSelect", arguments: "Status");
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
              height: 20,
            ),
            Text(
              "Client Source",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            SizedBox(
              height: 15,
            ),

            // Field Client Source
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
                      if (filterController.filterClientSourceList.isEmpty) {
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.text_3,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            filterController.filterClientSourceList.length,
                        itemBuilder: (context, index) {
                          final data =
                              filterController.filterClientSourceList[index];
                          return TagButton(
                            statusLabel: data['label'] ?? '-',
                            onPressed: () {
                              filterController.deleteFilterClientSource(data);
                            },
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed("/filterSelect",
                            arguments: "Client Source");
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
              height: 20,
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
          ],
        ),
      ),
    );
  }
}

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

  DateTime? temporaryStartDate;
  DateTime? temporaryEndDate;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Error message variables
  RxString startDateError = ''.obs;
  RxString endDateError = ''.obs;

  // Validation function
  void validateDateFields() {
    startDateError.value = '';
    endDateError.value = '';

    if (startDateController.text.isEmpty && endDateController.text.isNotEmpty) {
      startDateError.value = 'Start date must be filled';
    }
  }

  @override
  Widget build(BuildContext context) {
    filterController.fetchList('pic');
    filterController.fetchList('client_source');
    filterController.fetchList('category');

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  height: 30,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: () {
                      filterController.searchFilter('all');
                    },
                    child: Text(
                      "Clear filter",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
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
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        errorText: startDateError.value.isNotEmpty
                            ? startDateError.value
                            : null,
                      ),
                      readOnly: true,
                      controller: startDateController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: filterController.startDate.value ??
                              DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          temporaryStartDate = pickedDate;
                          startDateController.text =
                              DateFormat('dd MMM yyyy').format(pickedDate);
                          validateDateFields();
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
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                          errorText: endDateError.value.isNotEmpty
                              ? endDateError.value
                              : null,
                        ),
                        readOnly: true,
                        controller: endDateController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            temporaryEndDate = pickedDate;
                            endDateController.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                            validateDateFields();
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
                        Get.toNamed(
                          "/filterSelect",
                          arguments: {
                            'selectData': "category",
                            'controller': filterController,
                          },
                        );
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
                          final pic = filterController.filterPicList[index];
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
                        Get.toNamed(
                          "/filterSelect",
                          arguments: {
                            'selectData': "pic",
                            'controller': filterController,
                          },
                        );
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
                        Get.toNamed(
                          "/filterSelect",
                          arguments: {
                            'selectData': "client_source",
                            'controller': filterController,
                          },
                        );
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
                onPressed: () {
                  filterController.setDateRange(
                      temporaryStartDate, temporaryEndDate);
                  filterController.searchFilter('all');
                },
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

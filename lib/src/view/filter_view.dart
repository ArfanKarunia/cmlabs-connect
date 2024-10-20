import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';

class FilterView extends StatelessWidget {
  FilterView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final Rx<DateTime?> temporaryStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> temporaryEndDate = Rx<DateTime?>(null);

  final Rx<StatusLead?> temporaryStatusLead = Rx<StatusLead?>(null);

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(5)),
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
                  borderRadius: BorderRadius.circular(5)),
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
            Container(
              height: 51,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText),
                borderRadius: BorderRadius.circular(5),
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

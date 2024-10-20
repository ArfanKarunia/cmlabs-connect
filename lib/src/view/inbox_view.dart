import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/controllers/bottom_nav_controller.dart';
import 'package:quotation_app/src/controllers/filter_controller.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/widgets/custom_buttom.dart';
import 'package:quotation_app/src/widgets/select_status.dart';
import 'package:quotation_app/src/widgets/quotation_list_tile.dart';

class InboxView extends StatelessWidget {
  InboxView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final FilterController filterController = Get.put(FilterController());

  final BottomNavController navController = Get.put(BottomNavController());


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      color: Color(0xffF9F9F9),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quotations Inbox",
                      style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total Leads",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_1,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "  ${quotationController.quotationList.length}",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),

            // Search & Filter

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Search Field Input
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: TextFormField(
                        onChanged: quotationController.setSearch,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Company name, email, etc",
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_4,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Ionicons.search_outline,
                            size: 18,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.only(top: 0, bottom: 5),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: AppColors.primary,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.text_3, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 14,
                  ),

                  // Button Filter

                  SizedBox(
                    height: 34,
                    width: 34,
                    child: CustomButton(
                      onPressed: () {
                        print("Button pressed");
                        navController.toggleFilterVisibility();
                      },
                      child: Icon(
                        Ionicons.options_outline,
                        color: AppColors.text_3,
                        size: 28,
                      ), // Icon as child
                      backgroundColor:
                          AppColors.white_1, // Button background color
                      overlayColor: const Color.fromARGB(
                          100, 149, 149, 149), // Ripple effect color
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      side: BorderSide(color: AppColors.text_3, width: 1),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SelectStatus(
                controller: quotationController,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            // Obx(
            //   () {
            //     if (quotationController.filteredQuotations.isEmpty) {
            //       return const Center(child: Text('No quotations available.'));
            //     }
            
            //     return SizedBox(
            //       width: double.infinity,
            //       height: 500,
            //       child: ListView.builder(
            //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //         itemCount: quotationController.filteredQuotations.length,
            //         itemBuilder: (context, index) {
            //           var quotation =
            //               quotationController.filteredQuotations[index];
            //           return QuotationListTile(
            //             quotation: quotation,
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

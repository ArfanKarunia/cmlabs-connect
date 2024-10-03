import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/controllers/filter_controller.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/widgets/filter_status.dart';
import 'package:quotation_app/src/widgets/quotation_list_tile.dart';

class InboxView extends StatelessWidget {
  InboxView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      color: AppColors.white,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quotations Inbox",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${quotationController.quotationList.length}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      " Leads",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),

            // Search & Filter
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryText),
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                        onChanged: (value) {
                          quotationController.setSearch(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () {
                      return GestureDetector(
                        onTap: filterController.toggleFilterVisibility,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: filterController.filterVisible.value
                                  ? AppColors.primary
                                  : AppColors.primaryText,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Ionicons.options_outline,
                            color: filterController.filterVisible.value
                                ? AppColors.primary
                                : AppColors.primaryText,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            SelectStatus(
              controller: quotationController,
            ),

            const SizedBox(
              height: 15,
            ),

            Obx(
              () {
                if (quotationController.filteredQuotations.isEmpty) {
                  return const Center(child: Text('No quotations available.'));
                }

                return SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: quotationController.filteredQuotations.length,
                    itemBuilder: (context, index) {
                      var quotation =
                          quotationController.filteredQuotations[index];
                      return QuotationListTile(
                        quotation: quotation,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

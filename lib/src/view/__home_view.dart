import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/utils/icons.dart';
import 'package:quotation_app/src/widgets/dashboard_quotation.dart';
import 'package:quotation_app/src/widgets/select_status.dart';
import 'package:quotation_app/src/widgets/quotation_list_tile.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            const DashboardQuotation(),

            const SizedBox(
              height: 24,
            ),

            // Quotation Section

            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quotations",
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Text(
                            " Leads",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  SelectStatus(controller: quotationController,),
                  
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () {
                      List quotationList = quotationController.filteredQuotations;

                      if (quotationList.isEmpty) {
                        return const Center(child: Text('No quotations available.'));
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: 420,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          itemCount: min(quotationList.length, 5),
                          itemBuilder: (context, index) {
                            return QuotationListTile(
                              quotation: quotationList[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


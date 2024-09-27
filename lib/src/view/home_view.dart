import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/utils/icons.dart';
import 'package:quotation_app/src/widgets/dashboard_quotation.dart';
import 'package:quotation_app/src/widgets/filter_status.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            DashboardQuotation(),

            SizedBox(
              height: 24,
            ),

            // Quotation Section

            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quotations",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(
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
                      GestureDetector(
                        onTap: () {},
                        child: Text(
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
                  SizedBox(
                    height: 8,
                  ),

                  SelectStatus(controller: quotationController,),
                  
                  SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () {
                      List quotationList = quotationController.filteredQuotations;

                      if (quotationList.isEmpty) {
                        return Center(child: Text('No quotations available.'));
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: 420,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 0),
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


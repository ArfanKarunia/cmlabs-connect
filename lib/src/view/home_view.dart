import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/utils/icons.dart';
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
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 270,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2C74AE),
                          Color(0xFF3FA3F4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "John Doe",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    "Admin",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          // color: AppColors.primary,
                          // boxShadow: [
                          //   BoxShadow(
                          //       blurRadius: 10,
                          //       color: const Color.fromARGB(146, 0, 0, 0),
                          //       offset: Offset(0, -8),
                          //       spreadRadius: -8)
                          // ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 10,
                            childAspectRatio: 20 / 9,
                          ),
                          padding:
                              EdgeInsets.all(8.0), // padding around the grid
                          itemCount: 4, // total number of items
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.white, // color of grid items
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Positioned(
                                          bottom: 10,
                                          child: Text(
                                            "100",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "new leads",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  // Text(
                                  //   "100",
                                  //   style: TextStyle(
                                  //     fontSize: 24.0,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: AppColors.primary,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "new leads",
                                  //   style: TextStyle(
                                  //     fontSize: 12.0,
                                  //     color: AppColors.primaryText,
                                  //   ),
                                  // ),
                                  //   ],
                                  // ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            AppIcons.briefCase_outline),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

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
                            "1.469",
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
                              companyName: quotationList[index].companyName,
                              category: quotationList[index].category,
                              pic: quotationList[index].pic,
                              statusLead: quotationList[index].statusLead,
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/controllers/bottom_nav_controller.dart';
import 'package:quotation_app/src/controllers/dashboard_controller.dart';
import 'package:quotation_app/src/controllers/pic_controller.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/controllers/user_controller.dart';
import 'package:quotation_app/src/models/user_model.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/widgets/select_status.dart';
import 'package:quotation_app/src/widgets/metric_card.dart';
import 'package:quotation_app/src/widgets/quotation_list_tile.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final BottomNavController navController = Get.put(BottomNavController());
  
  final UserController userController = Get.put(UserController());
  
  final DashboardController dashboardController =
      Get.put(DashboardController());
  
  final PicController picController = Get.put(PicController());

  var acceptedData = 0;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // widget.picController.fetchNewPICData();
    // widget.dashboardController.saveDashboardData();
    // widget.quotationController.fetchQuotationData();
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget.userController.user.value;

    print("link gambar: ${user!.picUrl}");
    print("jumlah new: ${widget.dashboardController.amount_newLeads.value}");
    print(
        "jumlah accepted: ${widget.dashboardController.amount_acceptedLeads.value}");
    print(
        "jumlah followed up: ${widget.dashboardController.amount_followedUpLeads.value}");
    print(
        "jumlah last 30 day: ${widget.dashboardController.amount_last30Day.value}");

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.dashboardContainer),
                child: Column(
                  children: [
                    Row(
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
                                color: AppColors.white,
                                image: DecorationImage(
                                  image: (user.picUrl != null &&
                                          user.picUrl!.isNotEmpty)
                                      ? NetworkImage(user.picUrl!)
                                      : const AssetImage(
                                          "assets/icons/cmlabs_icon.png",
                                        ) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.name}",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text_1,
                                  ),
                                ),
                                Text(
                                  "${user.roleName}",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.text_2,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.text_1,
                                size: 35,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 13,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.danger,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Obx(
                      () {
                        return Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  MetricCard(
                                    count: widget.dashboardController
                                        .amount_newLeads.value,
                                    nameMetric: "New Leads",
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MetricCard(
                                    count: widget.dashboardController
                                        .amount_last30Day.value,
                                    nameMetric: "Last 30 Day",
                                    color: AppColors.purple,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  MetricCard(
                                    count: widget.dashboardController
                                        .amount_acceptedLeads.value,
                                    nameMetric: "Accepted",
                                    color: AppColors.success,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MetricCard(
                                    count: widget.dashboardController
                                        .amount_followedUpLeads.value,
                                    nameMetric: "Followed Up",
                                    color: AppColors.info,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            // Body (Qoutation List)

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Column(
                children: [
                  // Title and button View All

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quotations",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Obx(
                                () {
                                  return Text(
                                    "${widget.quotationController.quotationList.length}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                " Leads",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "View all",
                          style: GoogleFonts.plusJakartaSans(
                            decoration: TextDecoration.underline,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),

                  // Select Status, Filter Section, & Historical Lead History
                  Container(
                    child: SelectStatus(
                      controller: widget.quotationController,
                      isAccepted: false,
                      isRejected: false,
                      isFilterButton: true,
                      isHistorycalLeadButton: true,
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 14,
            ),

            // QOUTATION LIST

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                () {
                  List quotationList = widget.quotationController.filteredQuotations;

                  if (quotationList.isEmpty) {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.briefcase_outline,
                              color: AppColors.text_4,
                              size: 40,
                            ),
                            Text(
                              'No available data',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    height: 500,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      itemCount: min(quotationList.length, 10),
                      itemBuilder: (context, index) {
                        final quotation = quotationList[index];

                        return QuotationListTile(quotation: quotation);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

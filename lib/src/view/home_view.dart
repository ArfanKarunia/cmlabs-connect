import 'dart:io';

import 'package:cmlabs_connect/src/controllers/historical_lead_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../controllers/bottom_nav_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/filter_controller.dart';
import '../controllers/quotation_controller.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../utils/color.dart';
import '../widgets/metric_card.dart';
import '../widgets/quotation_list_tile.dart';
import '../widgets/select_status.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final BottomNavController navController = Get.put(
    BottomNavController(),
  );

  final UserController userController = Get.put(
    UserController(),
  );
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );
  final FilterController filterController = Get.put(
    FilterController(),
  );
  final HistoricalLeadController historicalLeadController = Get.put(
    HistoricalLeadController(),
  );

  late ScrollController scrollController;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    quotationController.fetchQuotationData();

    _refreshController.loadComplete();
  }

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    widget.historicalLeadController.clear();
    widget.scrollController = ScrollController();

    bool isLoadMoreInProgress = false;

    widget.scrollController.addListener(() async {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        if (isLoadMoreInProgress) return;

        isLoadMoreInProgress = true;

        await Future.delayed(Duration(milliseconds: 500));

        await widget.quotationController.loadMoreQuotations();

        isLoadMoreInProgress = false;
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget.userController.user.value;
    user!.picUrl;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.white_1,
            title: const Text("Konfirmasi Keluar"),
            content:
                const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  // Langsung keluar aplikasi
                  if (Platform.isAndroid) {
                    SystemNavigator.pop(); // Untuk Android
                  } else if (Platform.isIOS) {
                    exit(0); // Untuk iOS
                  }
                },
                child: const Text("Keluar"),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        body: Column(
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
                                  widget.userController.roleName.value,
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
                              onPressed: () {
                                Get.toNamed(AppRoutes.notification);
                              },
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
                        onTap: () {
                          widget.navController.changePage(1);
                        },
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

            Obx(
              () {
                return widget.quotationController.newQuotationCount.value > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: IntrinsicWidth(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStatePropertyAll(AppColors.primary),
                              foregroundColor:
                                  WidgetStatePropertyAll(AppColors.white_1),
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.white30),
                            ),
                            onPressed: () {
                              widget.quotationController.fetchQuotationData();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Ionicons.arrow_up_outline,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${widget.quotationController.newQuotationCount.value}+ New Leads",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              },
            ),

            // QOUTATION LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () {
                    List quotationList =
                        widget.quotationController.filteredQuotations;

                    return quotationList.isEmpty
                        ? Container(
                            height: 300,
                            width: double.infinity,
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
                          )
                        : Container(
                            width: double.infinity,
                            child: SmartRefresher(
                              enablePullDown: true,
                              header: ClassicHeader(
                                refreshStyle: RefreshStyle.Follow,
                                refreshingIcon: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.text_4,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              onRefresh: widget._onRefresh,
                              onLoading: widget._onLoading,
                              controller: widget._refreshController,
                              child: ListView.builder(
                                controller: widget.scrollController,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                itemCount: widget.quotationController
                                    .filteredQuotations.length,
                                itemBuilder: (context, index) {
                                  final quotation = quotationList[index];

                                  return Column(
                                    children: [
                                      QuotationListTile(
                                        quotation: quotation,
                                        onDelete: () {
                                          print(quotation.id);
                                          // widget.quotationController.deleteDataQuotation(quotation.id);
                                        },
                                        onChatWA: () {
                                          // print(quotation);
                                          widget.quotationController
                                              .redirectToWhatsapp(quotation);
                                        },
                                      ),
                                      (index + 1 ==
                                              widget.quotationController
                                                  .filteredQuotations.length)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.text_4,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                  },
                ),
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

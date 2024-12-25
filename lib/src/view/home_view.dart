import 'package:cmlabs_connect/src/controllers/historical_lead_controller.dart';
import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
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
import '../controllers/user_controler.dart';
import '../models/user_model.dart';
import '../utils/color.dart';
import '../widgets/metric_card.dart';
import '../widgets/quotation_list_tile.dart';
import '../widgets/select_status.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final QuotationController quotationController =
      Get.put(QuotationController());

  final BottomNavController navController = Get.put(
    BottomNavController(),
  );

  final UserControler userController = Get.put(
    UserControler(),
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

  final NotificationController notificationController =
      Get.put(NotificationController());

  late ScrollController scrollController;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    quotationController.fetchQuotationData(refreshData: true);

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
  void initState() {
    super.initState();

    historicalLeadController.clear();
    scrollController = ScrollController();

    bool isLoadMoreInProgress = false;

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isLoadMoreInProgress) return;

        isLoadMoreInProgress = true;

        await Future.delayed(Duration(milliseconds: 500));

        await quotationController.loadMoreQuotations();

        isLoadMoreInProgress = false;
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks

    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notificationController.fetchAmountUnreadNotification();

    dashboardController.saveDashboardData();

    quotationController.refreshNewData();

    User user = userController.user.value!;

    return Scaffold(
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
                                userController.roleName.value,
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
                          Obx(
                            () {
                              return notificationController.unreadAll.value != 0
                                  ? Positioned(
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
                                  : SizedBox.shrink();
                            },
                          ),
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
                                  count:
                                      dashboardController.amount_newLeads.value,
                                  nameMetric: "New Leads",
                                  color: AppColors.primary,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                MetricCard(
                                  count: dashboardController
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
                                  count: dashboardController
                                      .amount_acceptedLeads.value,
                                  nameMetric: "Accepted",
                                  color: AppColors.success,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                MetricCard(
                                  count: dashboardController
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
                                  "${quotationController.totalLeads.value}",
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
                        navController.changePage(1);
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
                    controller: quotationController,
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
              return quotationController.newQuotationCount.value > 0
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
                            quotationController.clearFilter();

                            quotationController.refreshNewData();

                            quotationController.fetchQuotationData();
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
                                "${quotationController.newQuotationCount.value}+ New Leads",
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
                  List quotationList = quotationController.quotationList;

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
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            controller: _refreshController,
                            child: ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              itemCount:
                                  quotationController.quotationList.length,
                              itemBuilder: (context, index) {
                                final quotation = quotationList[index];

                                var lengthQuotation =
                                    quotationController.quotationList.length;

                                return Column(
                                  children: [
                                    QuotationListTile(
                                      quotation: quotation,
                                      onDelete: () async {
                                        Get.back();

                                        await quotationController
                                            .deleteQuotationWithAnimation(
                                                index);
                                      },
                                      onChatWA: () {
                                        // print(quotation);

                                        quotationController
                                            .redirectToWhatsapp(quotation);
                                      },
                                    ),
                                    (index + 1 ==
                                                quotationController
                                                    .quotationList.length &&
                                            lengthQuotation % 10 == 0)
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.text_4,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : (index + 1 ==
                                                quotationController
                                                    .quotationList.length)
                                            ? Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Center(
                                                  child: Text(
                                                    "No more data",
                                                    style: GoogleFonts
                                                        .plusJakartaSans(
                                                      fontSize: 14,
                                                      color: AppColors.text_4,
                                                    ),
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
    );
  }
}

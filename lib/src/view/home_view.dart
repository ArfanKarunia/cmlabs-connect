import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../controllers/inbox/case_studies/case_studies_controller.dart';
import '../routes.dart';
import '../constant/fontstyle.dart';
import '../controllers/bottom_nav/bottom_nav_controller.dart';
import '../controllers/dashboard/dashboard_controller.dart';
import '../controllers/historical_lead_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/inbox/quotation/quotation_controller.dart';
import '../controllers/user/user_controller.dart';
import '../models/case_studies_model.dart';
import '../models/quotation_model.dart';
import '../utils/color.dart';
import '../widgets/custom_avatar.dart';
import '../widgets/empty_state.dart';
import '../widgets/inbox_list_tile.dart';
import '../widgets/metric_card.dart';
import '../widgets/select_status.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HistoricalLeadController historicalLeadController = Get.put(HistoricalLeadController());
  final NotificationController notificationController = Get.put(NotificationController());

  final BottomNavController navController = Get.find<BottomNavController>();
  final DashboardController dashboardController = Get.find<DashboardController>();
  final UserController userController = Get.find<UserController>();

  final CaseStudiesController caseStudiesController = Get.find<CaseStudiesController>();
  final QuotationController quotationController = Get.find<QuotationController>();

  @override
  void initState() {
    super.initState();
    historicalLeadController.clear();
  }

  @override
  Widget build(BuildContext context) {
    notificationController.fetchAmountUnreadNotification();
    final user = userController.user.value;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.dashboardContainer,
            ),
            child: Column(
              children: [
                // User details and notif icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomAvatar(
                          radius: 24,
                          link: user?.picUrl,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'cmlabs User',
                              style: bold.copyWith(fontSize: 16),
                            ),
                            Text(
                              userController.roleName.value,
                              style: regular.copyWith(
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
                          onPressed: () => Get.toNamed(AppRoutes.notification),
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.text_1,
                            size: 28,
                          ),
                        ),
                        Obx(
                          () => notificationController.unreadAll.value != 0
                              ? Positioned(
                                  top: 10,
                                  right: 13,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.danger,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Obx(
                  () => Column(
                    children: [
                      Row(
                        children: [
                          MetricCard(
                            count: dashboardController.newLeads.value,
                            nameMetric: "New Leads",
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          MetricCard(
                            count: dashboardController.last30Day.value,
                            nameMetric: "Last 30 Day",
                            color: AppColors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          MetricCard(
                            count: dashboardController.acceptedLeads.value,
                            nameMetric: "Accepted",
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 10),
                          MetricCard(
                            count: dashboardController.followedUpLeads.value,
                            nameMetric: "Followed Up",
                            color: AppColors.info,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Body (Qoutation List)
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Inbox Leads",
                    style: bold.copyWith(
                      fontSize: 20,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          "${quotationController.totalLeads.value} ",
                          style: regular.copyWith(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Text(
                        "Leads",
                        style: regular.copyWith(
                          fontSize: 12,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 7),

              // Select Status, Filter Section, & Historical Lead History
              SelectStatus(
                controllers: [quotationController, caseStudiesController],
                enableFilter: true,
                enableHistory: true,
              )
            ],
          ),

          const SizedBox(height: 20),

          // Obx(
          //   () => quotationController.newQuotationCount.value > 0
          //       ? Padding(
          //           padding: const EdgeInsets.only(bottom: 10),
          //           child: IntrinsicWidth(
          //             child: ElevatedButton(
          //               style: ButtonStyle(
          //                 shape: WidgetStatePropertyAll(
          //                   RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(5),
          //                   ),
          //                 ),
          //                 backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
          //                 foregroundColor: const WidgetStatePropertyAll(AppColors.white_1),
          //                 overlayColor: const WidgetStatePropertyAll(Colors.white30),
          //               ),
          //               onPressed: () {
          //                 quotationController.clearFilter();

          //                 quotationController.refreshNewData();

          //                 quotationController.fetchQuotation();
          //               },
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   const Icon(
          //                     Ionicons.arrow_up_outline,
          //                     size: 18,
          //                   ),
          //                   const SizedBox(width: 10),
          //                   Text(
          //                     "${quotationController.newQuotationCount.value}+ New Leads",
          //                     style: regular.copyWith(fontSize: 12),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         )
          //       : const SizedBox.shrink(),
          // ),

          // QOUTATION LIST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quotations',
                style: bold.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryText,
                ),
              ),
              GestureDetector(
                onTap: () => navController.changePage(1),
                child: Text(
                  "View all",
                  style: regular.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            List<Quotation> quotationList = quotationController.quotationList.take(3).toList();
            return quotationController.quotationList.isNotEmpty
                ? Column(
                    children: quotationList.map((quotation) {
                      return QuotationListTile(
                        quotation: quotation,
                        quotationController: quotationController,
                      );
                    }).toList(),
                  )
                : const SizedBox(height: 150, child: EmptyState());
          }),

          const SizedBox(height: 20),

          // CASE STUDIES LIST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Case Studies',
                style: bold.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryText,
                ),
              ),
              GestureDetector(
                onTap: () => navController.changePage(1),
                child: Text(
                  "View all",
                  style: regular.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            List<CaseStudies> caseStudiesList = caseStudiesController.caseStudiesList.take(3).toList();
            return Column(
              children: caseStudiesList.map((caseStudies) {
                return CaseStudiesListTile(
                  caseStudies: caseStudies,
                  caseStudiesController: caseStudiesController,
                );
              }).toList(),
            );
          }),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: Obx(
          //       () {
          //         List quotationList = quotationController.quotationList;

          //         return quotationList.isEmpty
          //             ? SizedBox(
          //                 height: 300,
          //                 width: double.infinity,
          //                 child: Center(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(
          //                         Ionicons.briefcase_outline,
          //                         color: AppColors.text_4,
          //                         size: 40,
          //                       ),
          //                       Text(
          //                         'No available data',
          //                         style: bold.copyWith(
          //                           fontSize: 24,
          //                           color: AppColors.text_4,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               )
          //             : SizedBox(
          //                 width: double.infinity,
          //                 child: SmartRefresher(
          //                   enablePullDown: true,
          //                   header: const ClassicHeader(
          //                     refreshStyle: RefreshStyle.Follow,
          //                     refreshingIcon: SizedBox(
          //                       width: 20,
          //                       height: 20,
          //                       child: CircularProgressIndicator(
          //                         color: AppColors.text_4,
          //                         strokeWidth: 2,
          //                       ),
          //                     ),
          //                   ),
          //                   onRefresh: _onRefresh,
          //                   onLoading: _onLoading,
          //                   controller: _refreshController,
          //                   child: ListView.builder(
          //                     controller: scrollController,
          //                     shrinkWrap: true,
          //                     physics: const AlwaysScrollableScrollPhysics(),
          //                     padding: const EdgeInsets.symmetric(vertical: 0),
          //                     itemCount: quotationController.quotationList.length,
          //                     itemBuilder: (context, index) {
          //                       final quotation = quotationList[index];

          //                       var lengthQuotation = quotationController.quotationList.length;

          //                       return Column(
          //                         children: [
          //                           QuotationListTile(
          //                             quotation: quotation,
          //                             onDelete: () async {
          //                               Get.back();

          //                               await quotationController.deleteQuotation(index);
          //                             },
          //                             onChatWA: () {
          //                               // print(quotation);

          //                               quotationController.redirectToWhatsapp(quotation);
          //                             },
          //                           ),
          //                           (index + 1 == quotationController.quotationList.length && lengthQuotation % 10 == 0)
          //                               ? const Padding(
          //                                   padding: EdgeInsets.symmetric(vertical: 10),
          //                                   child: Center(
          //                                     child: CircularProgressIndicator(
          //                                       color: AppColors.text_4,
          //                                       strokeWidth: 2,
          //                                     ),
          //                                   ),
          //                                 )
          //                               : (index + 1 == quotationController.quotationList.length)
          //                                   ? Container(
          //                                       width: double.infinity,
          //                                       padding: const EdgeInsets.symmetric(vertical: 10),
          //                                       child: Center(
          //                                         child: Text(
          //                                           "No more data",
          //                                           style: regular.copyWith(color: AppColors.text_4),
          //                                         ),
          //                                       ),
          //                                     )
          //                                   : const SizedBox.shrink(),
          //                         ],
          //                       );
          //                     },
          //                   ),
          //                 ),
          //               );
          //       },
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

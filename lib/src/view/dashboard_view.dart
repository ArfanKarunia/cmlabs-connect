import 'package:cmlabs_connect/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';

import '../controllers/inbox/case_studies/case_studies_controller.dart';
import '../controllers/inbox/contact_us/contact_us_controller.dart';
import '../controllers/inbox/faq/faq_controller.dart';
import '../models/inbox/contact_us_model.dart';
import '../models/inbox/faq_model.dart';
import '../routes.dart';
import '../constant/fontstyle.dart';
import '../controllers/dashboard/dashboard_controller.dart';
// import '../controllers/historical_lead_controller.dart';
import '../controllers/notification/notification_controller.dart';
import '../controllers/inbox/quotation/quotation_controller.dart';
import '../controllers/user/user_controller.dart';
import '../models/inbox/case_studies_model.dart';
import '../models/inbox/quotation_model.dart';
import '../utils/color.dart';
import '../widgets/custom_avatar.dart';
import '../widgets/empty_state.dart';
import '../widgets/inbox/inbox_list_tile.dart';
import '../widgets/metric_card.dart';
import '../widgets/select_status.dart';

class DashboardView extends StatefulWidget {
  final Function(int) updateIndex;
  const DashboardView({super.key, required this.updateIndex});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final NotificationController notificationController = Get.find<NotificationController>();
  final DashboardController dashboardController = Get.find<DashboardController>();
  final UserController userController = Get.find<UserController>();

  final QuotationController quotationController = Get.find<QuotationController>();
  final CaseStudiesController caseStudiesController = Get.find<CaseStudiesController>();
  final ContactUsController contactUsController = Get.find<ContactUsController>();
  final FaqController faqController = Get.find<FaqController>();

  @override
  Widget build(BuildContext context) {
    final user = userController.user.value;

    return Container(
      color: AppColors.primary,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => handleRefreshDashboard(),
        child: CustomScrollView(
          slivers: [
            _buildDashboardOverview(user),
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(color: AppColors.primary),
                  Container(
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                  ),
                ],
              ),
            ),
            SliverStickyHeader(
              header: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inbox Leads",
                      style: bold.copyWith(fontSize: 20, color: AppColors.primaryText),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            "${quotationController.totalLeads.value} ",
                            style: regular.copyWith(fontSize: 12, color: AppColors.primary),
                          ),
                        ),
                        Text(
                          "Leads",
                          style: regular.copyWith(fontSize: 12, color: AppColors.primaryText),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    // Select Status, Filter Section, & Historical Lead History
                    SelectStatus(
                      controllers: [
                        quotationController,
                        caseStudiesController,
                        contactUsController,
                        faqController,
                      ],
                      enableFilter: true,
                      enableHistory: true,
                    ),
                  ],
                ),
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quotations',
                                style: bold.copyWith(fontSize: 20, color: AppColors.primaryText),
                              ),
                              GestureDetector(
                                onTap: () => widget.updateIndex(1),
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
                          Obx(
                            () {
                              List<Quotation> quotationList =
                                  quotationController.quotationList.take(3).toList();
                              return quotationList.isNotEmpty
                                  ? Column(
                                      children: quotationList.map((quotation) {
                                        return QuotationListTile(
                                          quotation: quotation,
                                          quotationController: quotationController,
                                        );
                                      }).toList(),
                                    )
                                  : const SizedBox(height: 150, child: EmptyState());
                            },
                          ),

                          const SizedBox(height: 20),

                          // CASE STUDIES LIST
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Case Studies',
                                style: bold.copyWith(fontSize: 20, color: AppColors.primaryText),
                              ),
                              DashboardViewAllInbox(
                                onTap: () => widget.updateIndex(1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () {
                              List<CaseStudies> caseStudiesList =
                                  caseStudiesController.caseStudiesList.take(3).toList();
                              return caseStudiesList.isNotEmpty
                                  ? Column(
                                      children: caseStudiesList.map((caseStudies) {
                                        return CaseStudiesListTile(
                                          caseStudies: caseStudies,
                                          caseStudiesController: caseStudiesController,
                                        );
                                      }).toList(),
                                    )
                                  : const SizedBox(height: 150, child: EmptyState());
                            },
                          ),
                          const SizedBox(height: 20),

                          // CONTACT US LIST
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Contact Us',
                                style: bold.copyWith(fontSize: 20, color: AppColors.primaryText),
                              ),
                              DashboardViewAllInbox(
                                onTap: () => widget.updateIndex(1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () {
                              List<ContactUs> contactUsList =
                                  contactUsController.contactUsList.take(3).toList();
                              return contactUsList.isNotEmpty
                                  ? Column(
                                      children: contactUsList.map((contactUs) {
                                        return ContactUsListTile(
                                          contactUs: contactUs,
                                          contactUsController: contactUsController,
                                        );
                                      }).toList(),
                                    )
                                  : const SizedBox(height: 150, child: EmptyState());
                            },
                          ),
                          const SizedBox(height: 20),

                          // FAQ LIST
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'FAQ',
                                style: bold.copyWith(fontSize: 20, color: AppColors.primaryText),
                              ),
                              DashboardViewAllInbox(
                                onTap: () => widget.updateIndex(1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () {
                              List<Faq> faqList = faqController.faqList.take(3).toList();
                              return faqList.isNotEmpty
                                  ? Column(
                                      children: faqList.map((faq) {
                                        return FaqListTile(
                                          faq: faq,
                                          faqController: faqController,
                                        );
                                      }).toList(),
                                    )
                                  : const SizedBox(height: 150, child: EmptyState());
                            },
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleRefreshDashboard() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    dashboardController.fetchDashboardData();
    await quotationController.fetchList(refreshData: true);
    caseStudiesController.fetchList(refreshData: true);
    contactUsController.fetchList(refreshData: true);
    faqController.fetchList(refreshData: true);
  }

  SliverToBoxAdapter _buildDashboardOverview(User? user) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            // User details and notif icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomAvatar(
                        radius: 24,
                        link: user?.picUrl,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'cmlabs User',
                              style: bold.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userController.roleName.value,
                              style: regular.copyWith(fontSize: 12, color: AppColors.text_2),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
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
                  const SizedBox(height: 8),
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
    );
  }
}

class DashboardViewAllInbox extends StatelessWidget {
  final VoidCallback onTap;
  const DashboardViewAllInbox({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        "View all",
        style: regular.copyWith(
          fontSize: 12,
          color: AppColors.primary,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primary,
        ),
      ),
    );
  }
}

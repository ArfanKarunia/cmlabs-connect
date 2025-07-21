import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/top_pics/top_pics_controller.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import '../../utils/string_utils.dart';
import '../../widgets/analytics/details/date_type_button.dart';
import '../../widgets/analytics/details/quick_sort_button.dart';
import '../../widgets/analytics/details/quotation_overview_card.dart';
import '../../widgets/analytics/details/sort_option_radio.dart';
import '../../widgets/analytics/top_pics_card.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/empty_state.dart';

class DetailTopPICsView extends StatefulWidget {
  const DetailTopPICsView({super.key});

  @override
  State<DetailTopPICsView> createState() => _DetailTopPICsViewState();
}

class _DetailTopPICsViewState extends State<DetailTopPICsView> {
  final controller = Get.find<TopPICsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar(
        'Analytics',
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Image.asset('assets/icons/icon_filter.png', height: 32, width: 32),
              onPressed: () => Get.toNamed(
                AppRoutes.analyticsFilterView,
                arguments: {
                  'analyticsType': AnalyticsType.topPICs,
                  'controller': controller,
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Type
            Obx(
              () => Row(
                children: [
                  DateTypeButton(
                    title: 'This Week',
                    isSelected: controller.selectedDateType.value == DateType.weekly,
                    onTap: () => controller.setDateType(dateType: DateType.weekly),
                  ),
                  DateTypeButton(
                    title: 'This Month',
                    isSelected: controller.selectedDateType.value == DateType.monthly,
                    onTap: () => controller.setDateType(dateType: DateType.monthly),
                  ),
                  DateTypeButton(
                    title: 'This Year',
                    isSelected: controller.selectedDateType.value == DateType.yearly,
                    onTap: () => controller.setDateType(dateType: DateType.yearly),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Chart
                  const TopPICsCard(),

                  const SizedBox(height: 16),

                  Text(
                    'Quotation Overview',
                    style: bold.copyWith(fontSize: 20),
                  ),

                  const SizedBox(height: 6),

                  // Total Quotation
                  Obx(
                    () => RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${controller.topPICs.value?.totalQuotation}  ',
                            style: regular.copyWith(fontSize: 12, color: Colors.blue),
                          ),
                          TextSpan(
                            text: 'Leads',
                            style: regular.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Quick Sort
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 25,
                          child: Obx(
                            () => ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                QuickSortButton(
                                  title: 'Most',
                                  isSelected: controller.selectedSortOption.value == SortOption.totalMost,
                                  onTap: () => controller.setAnalyticsSortOption(sortOption: SortOption.totalMost),
                                ),
                                QuickSortButton(
                                  title: 'Least',
                                  isSelected: controller.selectedSortOption.value == SortOption.totalLeast,
                                  onTap: () => controller.setAnalyticsSortOption(sortOption: SortOption.totalLeast),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => showQuotationTrafficSortModal(context, controller: controller),
                        child: Row(
                          children: [
                            Text(
                              'Sort by',
                              style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Ionicons.chevron_down,
                              color: AppColors.text_3,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Top Services Data
                  Obx(
                    () => Column(
                      children: controller.dataLength > 0
                          ? List.generate(
                              controller.dataLength,
                              (index) => QuotationOverviewCard(
                                date: formatPICName(controller.data?.topPics[index].picName ?? ''),
                                totalQuotation: controller.data?.topPics[index].quotationCount ?? 0,
                                percentage: controller.data?.topPics[index].percentage ?? 0,
                                newCount: controller.data?.topPics[index].newCount ?? 0,
                                followedUpCount: controller.data?.topPics[index].followedUp ?? 0,
                                acceptedCount: controller.data?.topPics[index].accepted ?? 0,
                                rejectedCount: controller.data?.topPics[index].rejected ?? 0,
                              ),
                            )
                          : [
                              const SizedBox(height: 20),
                              const EmptyState(),
                            ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

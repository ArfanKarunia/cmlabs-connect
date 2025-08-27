import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/quotation_trends/quotation_trends_controller.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import '../../widgets/analytics/details/date_type_button.dart';
import '../../widgets/analytics/details/quick_sort_button.dart';
import '../../widgets/analytics/details/quotation_overview_card.dart';
import '../../widgets/analytics/details/quotation_overview_loading_card.dart';
import '../../widgets/analytics/details/sort_option_radio.dart';
import '../../widgets/analytics/quotation_trends_card.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/empty_state.dart';

class DetailQuotationTrendsView extends StatefulWidget {
  const DetailQuotationTrendsView({super.key});

  @override
  State<DetailQuotationTrendsView> createState() => _DetailQuotationTrendsViewState();
}

class _DetailQuotationTrendsViewState extends State<DetailQuotationTrendsView> {
  final controller = Get.find<QuotationTrendsController>();

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
            child: Obx(
              () => Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const ImageIcon(
                      AssetImage('assets/icons/icon_filter.png'),
                      size: 32,
                      color: AppColors.text_1,
                    ),
                    onPressed: () => Get.toNamed(
                      AppRoutes.analyticsFilterView,
                      arguments: {
                        'analyticsType': AnalyticsType.quotationTrends,
                        'controller': controller,
                      },
                    ),
                  ),
                  if (controller.isFilterApplied) ...[
                    const CircleAvatar(radius: 7, backgroundColor: AppColors.primary),
                  ],
                ],
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
                    title: 'Monthly',
                    isSelected: controller.selectedDateType.value == DateType.monthly,
                    onTap: () => controller.setDateType(dateType: DateType.monthly),
                  ),
                  DateTypeButton(
                    title: 'Yearly',
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
                  const QuotationTrendsCard(),

                  const SizedBox(height: 16),

                  Text(
                    'Quotation Overview',
                    style: bold.copyWith(fontSize: 20),
                  ),

                  const SizedBox(height: 6),

                  // Total Quotation
                  // Obx(
                  // () =>
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '-  ',
                          style: regular.copyWith(fontSize: 12, color: Colors.blue),
                        ),
                        TextSpan(
                          text: 'Leads',
                          style: regular.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // ),

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
                                  title: 'Newest',
                                  isSelected: controller.selectedSortOption.value == SortOption.newestDate,
                                  onTap: () => controller.setAnalyticsSortOption(sortOption: SortOption.newestDate),
                                ),
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
                        onTap: () => showQuotationTrendsSortModal(context, controller: controller),
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
                    () => controller.isLoading.value
                        ? const QuotationOverviewLoadingListCard(height: 79)
                        : Column(
                            children: controller.dataLength > 0
                                ? List.generate(
                                    controller.dataLength,
                                    (index) => QuotationOverviewCard(
                                      date: controller.lineChart?[index].period ?? '',
                                      totalQuotation: controller.lineChart?[index].count ?? 0,
                                      percentage: controller.lineChart?[index].percentChange ?? 0,
                                      isGrowth: true,
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

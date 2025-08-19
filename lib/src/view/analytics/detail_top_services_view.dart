import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/top_services/top_services_controller.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import '../../utils/string_utils.dart';
import '../../widgets/analytics/details/date_type_button.dart';
import '../../widgets/analytics/details/quick_sort_button.dart';
import '../../widgets/analytics/details/quotation_overview_card.dart';
import '../../widgets/analytics/top_services_card.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/empty_state.dart';

class DetailTopServicesView extends StatefulWidget {
  const DetailTopServicesView({super.key});

  @override
  State<DetailTopServicesView> createState() => _DetailTopServicesViewState();
}

class _DetailTopServicesViewState extends State<DetailTopServicesView> {
  final controller = Get.find<TopServicesController>();

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
                        'analyticsType': AnalyticsType.topServices,
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
                  const TopServicesCard(),

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
                            text: '${controller.topServices.value?.totalQuotation}  ',
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
                  SizedBox(
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

                  const SizedBox(height: 16),

                  // Top Services Data
                  Obx(
                    () => Column(
                      children: controller.dataLength > 0
                          ? List.generate(
                              controller.dataLength,
                              (index) => QuotationOverviewCard(
                                date: formatServiceName(controller.data?.topServices[index].serviceName ?? ''),
                                totalQuotation: controller.data?.topServices[index].quotationCount ?? 0,
                                percentage: controller.data?.topServices[index].percentage ?? 0,
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

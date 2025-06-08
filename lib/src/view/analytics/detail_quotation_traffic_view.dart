import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/quotation_traffic/quotation_traffic_controller.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import '../../widgets/analytics/quotation_overview_card.dart';
import '../../widgets/analytics/quotation_traffic_card.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/empty_state.dart';

class DetailQuotationTrafficView extends StatefulWidget {
  const DetailQuotationTrafficView({super.key});

  @override
  State<DetailQuotationTrafficView> createState() => _DetailQuotationTrafficViewState();
}

class _DetailQuotationTrafficViewState extends State<DetailQuotationTrafficView> {
  final controller = Get.find<QuotationTrafficController>();

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
                  'analyticsType': AnalyticsType.quotationTraffic,
                  'controller': controller,
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Type
          Obx(
            () => Row(
              children: [
                DateTypeButton(
                  title: 'Daily',
                  isSelected: controller.selectedDateType.value == DateType.daily,
                  onTap: () => controller.setDateType(dateType: DateType.daily),
                ),
                DateTypeButton(
                  title: 'Weekly',
                  isSelected: controller.selectedDateType.value == DateType.weekly,
                  onTap: () => controller.setDateType(dateType: DateType.weekly),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Chart
                const QuotationTrafficCard(isDetail: true),

                const SizedBox(height: 16),

                Text(
                  'Quotation Overview',
                  style: bold.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${controller.quotationTraffic.value?.totalQuotation}  ',
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
                      onTap: () => _showSortModal(context),
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
                Obx(
                  () => Column(
                    children: controller.dataLength > 0
                        ? List.generate(
                            controller.dataLength,
                            (index) => QuotationOverviewCard(
                              date: controller.data?.labels[index] ?? '',
                              totalQuotation: controller.data?.data[index].total ?? 0,
                              newCount: controller.data?.data[index].statusSummary['new'] ?? 0,
                              followedUpCount: controller.data?.data[index].statusSummary['followed_up'] ?? 0,
                              acceptedCount: controller.data?.data[index].statusSummary['accepted'] ?? 0,
                              rejectedCount: controller.data?.data[index].statusSummary['rejected'] ?? 0,
                            ),
                          )
                        : [const EmptyState()],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              controller: scrollController,
              children: [
                Text(
                  'Sort by',
                  style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
                ),
                Text(
                  'Dates',
                  style: medium.copyWith(fontSize: 16),
                ),
                SortOptionRadio(
                  label: 'Newest Date',
                  controller: controller,
                  sortOption: SortOption.newestDate,
                ),
                SortOptionRadio(
                  label: 'Oldest Date',
                  controller: controller,
                  sortOption: SortOption.oldestDate,
                ),
                const SizedBox(height: 12),
                Text(
                  'Quotation Count per Status',
                  style: medium.copyWith(fontSize: 16),
                ),
                SortOptionRadio(
                  label: 'New (Most)',
                  controller: controller,
                  sortOption: SortOption.newMost,
                ),
                SortOptionRadio(
                  label: 'New (Least)',
                  controller: controller,
                  sortOption: SortOption.newLeast,
                ),
                SortOptionRadio(
                  label: 'Accepted (Most)',
                  controller: controller,
                  sortOption: SortOption.acceptedMost,
                ),
                SortOptionRadio(
                  label: 'Accepted (Least)',
                  controller: controller,
                  sortOption: SortOption.acceptedLeast,
                ),
                SortOptionRadio(
                  label: 'Rejected (Most)',
                  controller: controller,
                  sortOption: SortOption.rejectedMost,
                ),
                SortOptionRadio(
                  label: 'Rejected (Least)',
                  controller: controller,
                  sortOption: SortOption.rejectedLeast,
                ),
                SortOptionRadio(
                  label: 'Followed Up (Most)',
                  controller: controller,
                  sortOption: SortOption.followUpMost,
                ),
                SortOptionRadio(
                  label: 'Followed Up (Least)',
                  controller: controller,
                  sortOption: SortOption.followUpLeast,
                ),
                const SizedBox(height: 12),
                Text(
                  'Total Quotations',
                  style: medium.copyWith(fontSize: 16),
                ),
                SortOptionRadio(
                  label: 'Most Total Quotations',
                  controller: controller,
                  sortOption: SortOption.totalMost,
                ),
                SortOptionRadio(
                  label: 'Least Total Quotations',
                  controller: controller,
                  sortOption: SortOption.totalLeast,
                ),
                const SizedBox(height: 36),
              ],
            );
          },
        );
      },
    );
  }
}

class QuickSortButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const QuickSortButton({super.key, required this.title, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? AppColors.primary : AppColors.inactiveOption,
        ),
        child: Center(
          child: Text(
            title,
            style: regular.copyWith(
              fontSize: 11,
              color: isSelected ? AppColors.white : AppColors.text_3,
            ),
          ),
        ),
      ),
    );
  }
}

class SortOptionRadio extends StatelessWidget {
  final String label;
  final AnalyticsController controller;
  final SortOption sortOption;
  const SortOptionRadio({
    super.key,
    required this.label,
    required this.controller,
    required this.sortOption,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = controller.selectedSortOption.value == sortOption;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.setAnalyticsSortOption(sortOption: sortOption);
            Get.back();
          },
          child: Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : AppColors.white,
                  border: Border.all(color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: regular.copyWith(fontSize: 13, color: AppColors.text_1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class DateTypeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const DateTypeButton({super.key, required this.title, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: isSelected ? const Border(bottom: BorderSide(color: AppColors.primary)) : null,
            color: isSelected ? AppColors.bgPrimary : null,
          ),
          child: Text(
            title,
            style: semibold.copyWith(color: isSelected ? AppColors.primary : AppColors.text_2),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

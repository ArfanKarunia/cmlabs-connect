import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/analytics/analytics_controller.dart';
import '../../../utils/color.dart';

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

void showQuotationTrafficSortModal(
  BuildContext context, {
  required AnalyticsController controller,
}) {
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

void showTopPICsSortModal(
  BuildContext context, {
  required AnalyticsController controller,
}) {
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
                'Total/Presentase Quotations',
                style: medium.copyWith(fontSize: 16),
              ),
              SortOptionRadio(
                label: 'Most Total/Presentase Quotations',
                controller: controller,
                sortOption: SortOption.totalMost,
              ),
              SortOptionRadio(
                label: 'Least Total/Presentase Quotations',
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

void showQuotationTrendsSortModal(
  BuildContext context, {
  required AnalyticsController controller,
}) {
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
                'Total/Presentase Quotations',
                style: medium.copyWith(fontSize: 16),
              ),
              SortOptionRadio(
                label: 'Most Total/Presentase Quotations',
                controller: controller,
                sortOption: SortOption.totalMost,
              ),
              SortOptionRadio(
                label: 'Least Total/Presentase Quotations',
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
